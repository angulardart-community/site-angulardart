import 'dart:io';
import 'package:git/git.dart';
import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as p;

import 'constants.dart';

main(args) => grind(args);

List<String> examples = [];
String homeDir = (Platform.isWindows
        ? Platform.environment['UserProfile']
        : Platform.environment['HOME']) ??
    '';

/// Every log here will be foldable in Github Actions logs.
/// See the [docs](https://github.com/actions/toolkit/blob/main/docs/citemsommands.md#group-and-ungroup-log-lines)
/// for more info.
void groupLogs(String name, Function task) {
  print('::group::$name');
  task.call();
  print('::endgroup::');
}

@Task('Insert and update code excerpts in Markdown files')
@Depends('clean-frags')
void codeExcerpts() {}

@Task('Clean fragments (code excerpts)')
void cleanFrags() {
  if (Directory(fragPath).existsSync()) {
    delete(Directory(fragPath));
  }
}

@Task('Create code excerpts')
void createCodeExcerpts() {
  Pub.get();

  // Check if tmp/_fragments exists
  // It will create one if not
  if (!Directory(fragPath).existsSync()) {
    Directory(fragPath).createSync(recursive: true);
  }

  // Generate code excerpts
  Pub.run(
    'build_runner',
    arguments: [
      'build',
      '--delete-conflicting-outputs',
      '--config',
      'excerpt',
      '--output=$fragPath'
    ],
  );
}

@Task('Update code excerpts in Markdown files')
void updateCodeExcerpts() {
  // Check and create the $HOME/tmp directory.
  // code_excerpt_updater uses it
  if (!Directory(p.join(homeDir, 'tmp')).existsSync()) {
    Directory(p.join(homeDir, 'tmp')).createSync();
  }

  Pub.run(
    'code_excerpt_updater',
    arguments: [
      srcPath,
      '--fragment-dir-path',
      fragPath,
      '--indentation',
      '2',
      '--write-in-place',
      'tmp/code-excerpt-log.txt',
      '--escape-ng-interpolation',
      '--yaml',
      r'--replace=/\s*\/\/!<br>//g;/ellipsis(<\w+>)?(\(\))?;?/.../g;/\/\*(\s*\.\.\.\s*)\*\//$1/g;/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;',
    ],
  );
}

/// Use --refresh=all to delete everything and execute a clean new build;
/// --refresh=excerpts to only delete excerpts
/// --refresh=examples to delete code examples
///
/// If no arguments is appended, this program will only attempt to build
/// the site with `bundle exec jekyll build`
@Task('Build site')
// @Depends('activate-pkgs')
void build() {
  TaskArgs args = context.invocation.arguments;

  if (args.hasOption('refresh')) {
    if (args.getOption('refresh') == 'excerpts') {
      groupLogs('Clean code excerpts', cleanFrags);
      groupLogs('Create code excerpts', createCodeExcerpts);
      groupLogs('Update code excerpts in Markdown files', updateCodeExcerpts);
    } else if (args.getOption('refresh') == 'examples') {
      groupLogs('Clean built examples', deleteExamples);
      getExampleList();
      groupLogs('Get built examples', getBuiltExamples);
      groupLogs('Copy built examples to site folder', cpBuiltExamples);
    } else if (args.getOption('refresh') == 'all') {
      groupLogs('Clean build artifacts and temporary directories', clean);
      groupLogs('Create code excerpts', createCodeExcerpts);
      groupLogs('Update code excerpts in Markdown files', updateCodeExcerpts);
      getExampleList();
      groupLogs('Get built examples', getBuiltExamples);
      groupLogs('Copy built examples to site folder', cpBuiltExamples);
    } else {
      throw Exception('Can\'t find the option: ' + args.getOption('refresh')!);
    }
  }

  // Run `bundle install`, similar to `pub get` in Dart
  groupLogs('bundle install', () => run('bundle', arguments: ['install']));

  // Build site using [Jekyll](https://jekyllrb.com)
  groupLogs(
    'bundle exec jekyll build',
    () => run(
      'bundle',
      arguments: [
        'exec',
        'jekyll',
        'build',
      ],
    ),
  );
}

@DefaultTask()
void usage() => print('Run `grind --help` to list available tasks.');

@Task('Check and activate required global packages')
void activatePkgs() {
  PubApp webdev = PubApp.global('webdev');
  PubApp dartdoc = PubApp.global('dartdoc');
  PubApp sass = PubApp.global('sass');

  if (!webdev.isActivated) {
    // webdev.activate();
    run(
      'dart',
      arguments: [
        'pub',
        'global',
        'activate',
        'webdev',
        '2.7.4',
      ],
    );
  }
  if (!webdev.isGlobal) {
    throw GrinderException(
        'Can\'t find webdev! Did you add \"~/.pub-cache\" to your environment variables?');
  }
  log('webdev is activated');

  if (!dartdoc.isActivated) {
    dartdoc.activate();
  }
  if (!dartdoc.isGlobal) {
    throw GrinderException(
        'Can\'t find dartdoc! Did you add \"~/.pub-cache\" to your environment variables?');
  }
  log('dartdoc is activated');

  if (!sass.isActivated) {
    dartdoc.activate();
  }
  if (!sass.isGlobal) {
    throw GrinderException(
        'Can\'t find sass! Did you add \"~/.pub-cache\" to your environment variables?');
  }
  log('sass is activated');
}

//----------------------------Example Repos Related----------------------------//

@Task('Get the list of examples')
void getExampleList() {
  if (examples.isEmpty) {
    Directory('examples/acx').listSync().forEach((element) {
      if (element is Directory) {
        examples.add(p.basename(element.path));
      }
    });
    Directory('examples/ng/doc').listSync().forEach((element) {
      if (element is Directory) {
        // All examples don't contain "_" symbol in their names
        if (!p.basename(element.path).contains('_')) {
          examples.add(p.basename(element.path));
        }
      }
    });

    examples.sort();
  }
}

/// Every example has a corresponding live example.
/// We always upload the latest build to a Github repo,
/// so that we don't have to build an example for it to show
/// up on the site everytime
@Task('Get built examples')
@Depends('get-example-list')
void getBuiltExamples() async {
  if (!builtExamplesDir.existsSync()) {
    builtExamplesDir.createSync(recursive: true);
  }

  // We only need gh-pages branch
  void pullRepo(String name) => run(
        'git',
        arguments: [
          'clone',
          'https://github.com/angulardart-community/$name',
          '--branch',
          'gh-pages',
          '--single-branch',
          name,
          '--depth',
          '1',
        ],
        workingDirectory: builtExamplesDir.path,
        quiet: true,
      );

  for (String example in examples) {
    log('Fetching example $example');
    pullRepo(example);
  }
}

@Task('Copy built examples to the site folder')
void cpBuiltExamples() {
  builtExamplesDir.listSync().forEach((example) {
    String exampleName = p.basename(example.path);

    if (example is Directory) {
      copy(Directory(p.join(example.path, angularVersion.toString())),
          Directory('publish/examples/$exampleName'));

      // Modify <base href=...> to point to the correct directory
      // The example "lottery" needs to be special treated
      if (exampleName != 'lottery') {
        String href = p.join('/examples', exampleName);
        File index = File('publish/examples/$exampleName/index.html');
        index.writeAsStringSync(index.readAsStringSync().replaceFirst(
            '<base href=\"/$exampleName/$angularVersion/\">',
            '<base href=\"$href/\">'));
      }
    }
  });
}

@Task('Delete built examples')
void deleteExamples() {
  if (builtExamplesDir.existsSync()) {
    delete(builtExamplesDir);
  }
}

//----------------------------Utility----------------------------//

/// By default this cleans every temporary directory and build artifacts
/// If you don't want to delete something, pass that thing with a "no-"
/// flag.
/// For example, if you **DON'T** want to delete the "publish" folder,
/// run `grind clean --no-publish`. It will delete everything else.
@Task('Clean temporary directories and build artifacts')
void clean() {
  TaskArgs args = context.invocation.arguments;

  // Cleans the "publish" directory
  bool cleanSite = args.hasFlag('publish') ? args.getFlag('publish') : true;
  if (cleanSite && Directory('publish').existsSync()) {
    delete(Directory('publish'));
  }

  // Cleans the "$HOME/tmp" directory, used by some git stuffs
  bool cleanTmp = args.hasFlag('tmp') ? args.getFlag('tmp') : true;
  if (cleanTmp) {
    String path = p.join(
      // Please don't tell me you're on Android or iOS
      homeDir,
      'tmp',
    );
    if (Directory(path).existsSync()) {
      delete(Directory(path));
    }
  }

  // Cleans the "src./asset-cache" directory
  bool cleanAssetCache =
      args.hasFlag('asset-cache') ? args.getFlag('asset-cache') : true;
  if (cleanAssetCache && Directory('src/.asset-cache').existsSync()) {
    delete(Directory('src/.asset-cache'));
  }

  bool cleanCodeFrags =
      args.hasFlag('code-frags') ? args.getFlag('code-frags') : true;
  if (cleanCodeFrags) {
    cleanFrags();
  }

  bool cleanExamples =
      args.hasFlag('examples') ? args.getFlag('examples') : true;
  if (cleanExamples) {
    deleteExamples();
  }

  if (cleanCodeFrags && cleanExamples) {
    delete(Directory('tmp'));
  }
}

@Task('Clean temporary directories created when syncing examples to GitHub')
void deleteSync() {
  delete(Directory('tmp/sync'));
}

@Task('Sync changes made on the local example to the GitHub examples repo')
@Depends('get-example-list', 'delete-sync')
void syncExamples() async {
  final syncDir = Directory('tmp/sync')..createSync(recursive: true);
  final commitMsg = 'Auto-commit: update to Angular Version 6';
  print(examples);

  for (String example in examples) {
    if (!example.contains('lottery')) {
      final exampleDir = Directory('tmp/sync/$example');

      log('Cloning example $example');
      await runGit(
        [
          'clone',
          'https://github.com/angulardart-community/$example',
          '--depth',
          '1',
          '--branch',
          'master',
          '--single-branch',
          '$example',
        ],
        throwOnError: true,
        processWorkingDir: syncDir.path,
      );

      copy(Directory('examples/ng/doc/$example'), exampleDir);

      log('Saving changes...');
      await runGit(['add', '-u'], processWorkingDir: exampleDir.path);

      log('Commit changes...');
      await runGit([
        'commit',
        '-s',
        '-m',
        '"$commitMsg"',
      ], processWorkingDir: exampleDir.path);

      log('Push to remote...');
      await runGit(['push'], processWorkingDir: exampleDir.path);
      log('Done!\n');
    }
  }

  log('Cleaning up...');
  for (String example in examples) {
    delete(Directory('tmp/sync/$example'));
  }
}

@Task('A one-time command for executing repetitive tasks for each example')
@Depends('get-example-list')
void forEachExample() {
  for (var example in examples) {
    // Do something for each example

    // The following updates the default branch for each repo using GitHub API
    // final uri = Uri.https(
    //   'api.github.com',
    //   'repos/angulardart-community/$example',
    // );
    // await http.patch(
    //   uri,
    // 	headers: {
    // 		'Authorization': 'token <my token>',
    // 		'Accept': 'application/vnd.github.v3+json',
    // 	},
    // 	body: '{"default_branch": "master"}',
    // );
  }
}

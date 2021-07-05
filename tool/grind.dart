import 'dart:io';
import 'package:git/git.dart';
import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as p;

import 'constants.dart';
import 'build.dart';

main(args) => grind(args);

List<String> examples = [];

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
      File('tool/regex.txt')
          .readAsStringSync(), // A work around because for whatever reason Dart just doesn't recognize it
    ],
  );
}

@Task('Build site')
@Depends('clean-frags', 'create-code-excerpts', 'update-code-excerpts')
void build() {
	// Run `bundle install`, similar to `pub get` in Dart
	run('bundle', arguments: ['install']);

	// The site is built with [Jekyll](https://jekyllrb.com)
  run(
    'bundle',
    arguments: [
      'exec',
			'jekyll',
			'build',
    ],
  );
}

@DefaultTask()
void usage() => print('Run `grind --help` to list available tasks.');

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

@Task('Get built examples')
@Depends('get-example-list')
void getBuiltExamples() {
  Directory builtExamplesDir = Directory('tmp/deploy-repos/examples');
  if (builtExamplesDir.existsSync()) {
    // log();
  } else {}
}

/// By default this cleans every temporary directory and build artifacts
/// Because `grinder` doesn't have negatable falgs yet, if you don't
/// want to delete something, **PASS THAT THING** as a flag
///
/// For example, if you **DON'T** want to delete the "publish" folder,
/// run `grind clean --publish`. It will clean everything else.
@Task('Clean temporary directories and build artifacts')
clean() {
  // Ask grinder to add an negtable option
  TaskArgs args = context.invocation.arguments;

  // Cleans the "publish" directory
  bool cleanSite = !args.getFlag('publish');
  if (cleanSite && Directory('publish').existsSync()) {
    delete(Directory('publish'));
  }

  // Cleans the "$HOME/tmp" directory, used by some git stuffs
  bool cleanTmp = !args.getFlag('tmp');
  if (cleanTmp) {
    String path = p.join(
      // Please don't tell me you're on Android or iOS
      Platform.isWindows
          ? Platform.environment['UserProfile']
          : Platform.environment['HOME'],
      'tmp',
    );
    if (Directory(path).existsSync()) {
      delete(Directory(path));
    }
  }

  // Cleans the "src./asset-cache" directory
  bool cleanAssetCache = !args.getFlag('assetcache');
  if (cleanAssetCache && Directory('src/.asset-cache').existsSync()) {
    delete(Directory('src/.asset-cache'));
  }
}

import 'dart:io';
import 'package:git/git.dart';
import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as p;

main(args) => grind(args);

@Task('Build site')
build() {
  Pub.build();
}

@DefaultTask()
void usage() => print('Run `grind --help` to list available tasks.');

@Task('Sync examples')
syncExample() {

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

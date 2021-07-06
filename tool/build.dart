import 'dart:io';
import 'package:grinder/grinder.dart';

import 'constants.dart';

void build() {
  Pub.get();

  // Check if tmp/_fragments exists
  // It will create one if not
  if (!Directory(fragPath).existsSync()) {
    Directory(fragPath).createSync(recursive: true);
  }

  // Run various miscellaneous builds
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

  // Update code excerpts
  Pub.run(
    'code_excerpt_updater',
    arguments: [
      '--fragment-dir-path',
			fragPath,
    ],
  );
}

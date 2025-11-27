import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return TestAsyncUtils.guard<void>(() async {
    goldenFileComparator = _TolerantGoldenFileComparator(Uri.parse('test/'), pixelDifferenceThreshold: 0.01);
    await testMain();
  });
}

class _TolerantGoldenFileComparator extends LocalFileComparator {
  _TolerantGoldenFileComparator(super.testDirectory, {required this.pixelDifferenceThreshold});

  final double pixelDifferenceThreshold;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(imageBytes, await getGoldenBytes(golden));

    if (!result.passed) {
      final percentage = result.diffPercent;
      if (percentage <= pixelDifferenceThreshold) {
        debugPrint(
          'Golden file comparison passed with $percentage% difference '
          '(threshold: ${pixelDifferenceThreshold * 100}%)',
        );
        return true;
      }

      final error = await generateFailureOutput(result, golden, basedir);
      throw TestFailure(error);
    }

    return true;
  }

  @override
  Future<Uint8List> getGoldenBytes(Uri golden) async {
    final file = File.fromUri(golden);
    if (!file.existsSync()) {
      throw Exception(
        'Golden file does not exist: ${golden.path}\n'
        'To create a new golden file, run:\n'
        '  flutter test --update-goldens',
      );
    }
    return file.readAsBytes();
  }
}

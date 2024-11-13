// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'mac/main.dart';
import 'win/main.dart';

Future<void> main() async {
  if (kDebugMode) {
    await mainMac();
    return;
  }
  await mainWin();
  // if (defaultTargetPlatform == TargetPlatform.windows) {
  //   await mainWin();
  // } else if (defaultTargetPlatform == TargetPlatform.macOS) {
  //   await mainMac();
  // } else {
  //   throw UnsupportedError('Unsupported platform');
  // }
}

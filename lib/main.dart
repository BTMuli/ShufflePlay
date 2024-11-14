// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'mac/main.dart';
import 'win/main.dart';

Future<void> main() async {
  switch (defaultTargetPlatform) {
    case TargetPlatform.windows:
      await mainWin();
      break;
    case TargetPlatform.macOS:
      await mainMac();
      break;
    default:
      throw UnsupportedError('Unsupported platform');
  }
}

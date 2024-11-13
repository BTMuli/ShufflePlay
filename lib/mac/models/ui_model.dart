// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

extension MacosUiColorExtension on AccentColor {
  Color get color {
    switch (this) {
      case AccentColor.blue:
        return Colors.blue;
      case AccentColor.purple:
        return Colors.purple;
      case AccentColor.pink:
        return Colors.pink;
      case AccentColor.red:
        return Colors.red;
      case AccentColor.orange:
        return Colors.orange;
      case AccentColor.yellow:
        return Colors.yellow;
      case AccentColor.green:
        return Colors.green;
      case AccentColor.graphite:
        return Colors.grey;
    }
  }
}

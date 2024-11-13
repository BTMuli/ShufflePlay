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

enum InfoBarSeverity { error, warning, success, info }

extension InfobarSeverityExtension on InfoBarSeverity {
  Color get color {
    switch (this) {
      case InfoBarSeverity.error:
        return Colors.red;
      case InfoBarSeverity.warning:
        return Colors.orange;
      case InfoBarSeverity.success:
        return Colors.green;
      case InfoBarSeverity.info:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case InfoBarSeverity.error:
        return Icons.error;
      case InfoBarSeverity.warning:
        return Icons.warning;
      case InfoBarSeverity.success:
        return Icons.check_circle;
      case InfoBarSeverity.info:
        return Icons.info;
    }
  }
}

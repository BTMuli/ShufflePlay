// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import 'sp_icon.dart';

/// 对dialog的封装
class SpDialog {
  SpDialog._();

  static final SpDialog instance = SpDialog._();

  factory SpDialog() => instance;

  /// confirm dialog
  static Future<bool?> confirm(
    BuildContext context,
    String title,
    String content, {
    bool cancel = true,
  }) async {
    return await showMacosAlertDialog<bool>(
      barrierDismissible: cancel,
      context: context,
      builder: (_) {
        return MacosAlertDialog(
          appIcon: const SpAppIcon(),
          title: Text(title),
          message: Text(content),
          primaryButton: PushButton(
            onPressed: () => Navigator.of(context).pop(true),
            controlSize: ControlSize.large,
            child: const Text('确定'),
          ),
          secondaryButton: PushButton(
            onPressed: () => Navigator.of(context).pop(false),
            controlSize: ControlSize.large,
            secondary: true,
            child: const Text('取消'),
          ),
        );
      },
    );
  }

  /// input dialog
  static Future<String?> input(
    BuildContext context,
    String title,
    String content, {
    bool copy = false,
    bool cancel = true,
    String? label,
  }) async {
    TextEditingController input = TextEditingController();
    return await showMacosAlertDialog<String>(
      barrierDismissible: cancel,
      context: context,
      builder: (_) {
        return MacosAlertDialog(
          appIcon: const SpAppIcon(),
          title: Text(title),
          message: Row(
            children: <Widget>[
              Text('$content:'),
              const SizedBox(width: 8),
              Expanded(
                child: MacosTextField(
                  placeholder: label,
                  controller: input,
                ),
              ),
              const SizedBox(width: 8),
              if (copy)
                MacosIconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    var data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data != null) input.text = data.text!;
                  },
                ),
            ],
          ),
          primaryButton: PushButton(
            onPressed: () => Navigator.of(context).pop(input.text),
            controlSize: ControlSize.large,
            child: const Text('确定'),
          ),
          secondaryButton: PushButton(
            onPressed: () => Navigator.of(context).pop(),
            controlSize: ControlSize.large,
            secondary: true,
            child: const Text('取消'),
          ),
        );
      },
    );
  }
}

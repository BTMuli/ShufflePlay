// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 对dialog的封装
class SpDialog {
  SpDialog._();

  /// 实例
  static final SpDialog _instance = SpDialog._();

  /// 获取实例
  factory SpDialog() => _instance;

  /// confirm dialog
  static Future<bool?> confirm(
    BuildContext context,
    String title,
    String content, {
    bool cancel = true,
  }) async {
    return await showDialog<bool>(
      dismissWithEsc: cancel,
      barrierDismissible: cancel,
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            Button(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确定'),
            ),
            Button(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
          ],
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
    return await showDialog<String>(
      dismissWithEsc: cancel,
      barrierDismissible: cancel,
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Text(title),
          content: SizedBox(
            height: 42.h,
            child: Row(
              children: <Widget>[
                Text('$content:'),
                const SizedBox(width: 8),
                Expanded(child: TextBox(placeholder: label, controller: input)),
                const SizedBox(width: 8),
                if (copy)
                  IconButton(
                    icon: const Icon(FluentIcons.copy),
                    onPressed: () async {
                      var data = await Clipboard.getData(Clipboard.kTextPlain);
                      if (data != null) {
                        input.text = data.text!;
                      }
                    },
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            Button(
              onPressed: () => Navigator.of(context).pop(input.text),
              child: const Text('确定'),
            ),
            Button(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }
}

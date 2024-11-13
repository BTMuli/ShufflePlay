// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../models/ui_model.dart';
import 'sp_icon.dart';

class SpInfoBarType {
  /// severity
  final InfoBarSeverity severity;

  /// message
  final String message;

  /// context
  BuildContext context;

  /// constructor
  SpInfoBarType(
    this.context,
    this.message, {
    this.severity = InfoBarSeverity.info,
  });

  /// show
  Future<void> show() async {
    await showMacosAlertDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return MacosAlertDialog(
          title: MacosIcon(severity.icon, color: severity.color),
          appIcon: const SpAppIcon(),
          message: Text(message),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }
}

/// 消息队列
class SpInfobarQueue extends ChangeNotifier {
  SpInfobarQueue._();

  static final SpInfobarQueue instance = SpInfobarQueue._();

  factory SpInfobarQueue() => instance;
  final List<SpInfoBarType> infoQueue = [];

  List<SpInfoBarType> get infoBars => infoQueue;
  Timer? timer;

  Future<void> initTimer() async {
    if (infoBars.length == 1) {
      await infoBars.first.show();
      infoBars.removeAt(0);
      notifyListeners();
    }
    timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (infoBars.isNotEmpty) {
        infoBars.first.show();
        infoBars.removeAt(0);
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> add(SpInfoBarType infobar) async {
    infoBars.add(infobar);
    if (timer == null || !timer!.isActive) await initTimer();
    notifyListeners();
  }
}

/// 对SnackBar的封装
class SpInfobar {
  SpInfobar._();

  /// 实例
  static final SpInfobar instance = SpInfobar._();

  /// 获取实例
  factory SpInfobar() => instance;

  /// 队列
  static final infoBarQueue = SpInfobarQueue();

  /// show
  static Future<void> show(
    BuildContext context,
    String text,
    InfoBarSeverity severity,
  ) async {
    var infoBar = SpInfoBarType(context, text, severity: severity);
    return await infoBarQueue.add(infoBar);
  }

  /// bbs
  static Future<void> bbs(
    BuildContext context,
    BBSResp resp,
  ) async {
    var severity = InfoBarSeverity.success;
    if (resp.retcode != 0) severity = InfoBarSeverity.error;
    var str = '[${resp.retcode}] ${resp.message}';
    return await show(context, str, severity);
  }

  /// info
  static Future<void> info(BuildContext context, String text) async {
    return await show(context, text, InfoBarSeverity.info);
  }

  /// success
  static Future<void> success(BuildContext context, String text) async {
    return await show(context, text, InfoBarSeverity.success);
  }

  /// warning
  static Future<void> warn(BuildContext context, String text) async {
    return await show(context, text, InfoBarSeverity.warning);
  }

  /// error
  static Future<void> error(BuildContext context, String text) async {
    return await show(context, text, InfoBarSeverity.error);
  }
}

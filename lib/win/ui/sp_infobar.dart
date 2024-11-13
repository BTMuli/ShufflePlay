// Dart imports:
import 'dart:async';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';

class SpInfoBarType {
  /// info
  InfoBar infoBar;

  /// context
  BuildContext context;

  /// constructor
  SpInfoBarType(this.infoBar, this.context);

  /// show
  Future<void> show() async {
    await displayInfoBar(
      context,
      builder: (context, close) => infoBar,
      duration: const Duration(seconds: 2),
    );
  }
}

/// 消息队列
class SpInfobarQueue extends ChangeNotifier {
  SpInfobarQueue._();

  static final SpInfobarQueue _instance = SpInfobarQueue._();

  factory SpInfobarQueue() => _instance;

  final List<SpInfoBarType> _infoBars = [];

  List<SpInfoBarType> get infoBars => _infoBars;

  Timer? _timer;

  Future<void> initTimer() async {
    if (_infoBars.length == 1) {
      await _infoBars.first.show();
      _infoBars.removeAt(0);
      notifyListeners();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) async {
      if (_infoBars.isNotEmpty) {
        await _infoBars.first.show();
        _infoBars.removeAt(0);
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> add(SpInfoBarType infobar) async {
    _infoBars.add(infobar);
    if (_timer == null || !_timer!.isActive) {
      await initTimer();
    }
    notifyListeners();
  }
}

/// 对SnackBar的封装
class SpInfobar {
  SpInfobar._();

  /// 实例
  static final SpInfobar _instance = SpInfobar._();

  /// 获取实例
  factory SpInfobar() => _instance;

  /// 队列
  static final _infoBarQueue = SpInfobarQueue();

  /// show
  static Future<void> show(
    BuildContext context,
    String text,
    InfoBarSeverity severity,
  ) async {
    var infoBar = SpInfoBarType(
      InfoBar(title: Text(text), severity: severity),
      context,
    );
    return await _infoBarQueue.add(infoBar);
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

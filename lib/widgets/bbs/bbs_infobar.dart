// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../ui/sp_infobar.dart';

/// 针对BBS的信息栏
class BbsInfobar {
  BbsInfobar._();

  /// 实例
  static final BbsInfobar _instance = BbsInfobar._();

  /// 获取实例
  factory BbsInfobar() => _instance;

  /// 展示
  static Future<void> showResp(BuildContext context, BBSResp resp) async {
    var message = '[${resp.retcode}] ${resp.message}';
    if (resp.retcode == 0) {
      await SpInfobar.success(context, message);
    } else {
      await SpInfobar.error(context, message);
    }
  }
}

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Project imports:
import '../../models/bbs/login/bbs_login_qr_model.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../request/bbs/bbs_api_login_qr.dart';
import '../ui/sp_infobar.dart';

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

  /// 登录弹窗
  static Future<UserBBSModelCookie?> loginByQr(BuildContext context) async {
    var qrApi = SprBbsApiLoginQr();
    var codeResp = await qrApi.getLoginQr();
    if (codeResp.retcode != 0) {
      if (context.mounted) await SpInfobar.bbs(context, codeResp);
      return null;
    }
    var codeData = codeResp.data as BbsLoginQrGetQrData;
    var ticket = codeData.ticket;
    if (!context.mounted) return null;
    return await showDialog<UserBBSModelCookie?>(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Center(child: Text('扫码登录(米游社)')),
          content: SizedBox(
            height: 200.sp,
            child: Center(
              child: QrImageView(
                data: codeData.url,
                size: 200.sp,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          actions: <Widget>[
            Button(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('取消'),
            ),
            Button(
              onPressed: () async {
                var statusResp = await qrApi.getQRStatus(ticket);
                if (statusResp.retcode == -106) {
                  if (context.mounted) {
                    await SpInfobar.warn(context, '二维码已过期，请重新打开');
                  }
                  return;
                }
                if (statusResp.retcode != 0) {
                  if (context.mounted) await SpInfobar.bbs(context, statusResp);
                  return;
                }
                var statusData = statusResp.data as BbsLoginQrStatData;
                debugPrint(statusData.toJson().toString());
                if (statusData.status == "Created") {
                  if (context.mounted) {
                    await SpInfobar.warn(context, '请使用米游社扫码登录');
                  }
                  return;
                }
                if (statusData.status == "Scanned") {
                  if (context.mounted) {
                    await SpInfobar.warn(context, '请在米游社客户端确认登录');
                  }
                  return;
                }
                if (statusData.status != "Confirmed") {
                  if (context.mounted) {
                    await SpInfobar.warn(context, '未知状态，${statusData.status}');
                  }
                  return;
                }
                UserBBSModelCookie cookie = UserBBSModelCookie(
                  mid: statusData.userInfo!.mid,
                  stuid: statusData.userInfo!.aid,
                  ltuid: statusData.userInfo!.aid,
                  accountId: statusData.userInfo!.aid,
                  stoken: statusData.tokens[0].token,
                );
                if (context.mounted) Navigator.of(context).pop(cookie);
              },
              child: const Text('确定'),
            )
          ],
        );
      },
    );
  }
}

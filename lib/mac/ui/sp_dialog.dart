// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Project imports:
import '../../models/bbs/login/bbs_login_qr_model.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../request/bbs/bbs_api_login_qr.dart';
import 'sp_icon.dart';
import 'sp_infobar.dart';

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
            onPressed: () => Navigator.of(context).pop(null),
            controlSize: ControlSize.large,
            secondary: true,
            child: const Text('取消'),
          ),
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
    return await showMacosAlertDialog<UserBBSModelCookie?>(
      context: context,
      builder: (BuildContext context) {
        return MacosAlertDialog(
          appIcon: const SpAppIcon(),
          title: Center(child: Text('扫码登录(米游社)')),
          message: SizedBox(
            height: 200.sp,
            child: Center(
              child: QrImageView(
                data: codeData.url,
                size: 200.sp,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          secondaryButton: PushButton(
            onPressed: () => Navigator.of(context).pop(null),
            controlSize: ControlSize.large,
            secondary: true,
            child: const Text('取消'),
          ),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
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
          ),
        );
      },
    );
  }
}

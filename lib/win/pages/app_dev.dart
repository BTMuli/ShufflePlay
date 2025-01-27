// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Project imports:
import '../../models/bbs/login/bbs_login_qr_model.dart';
import '../../request/bbs/bbs_api_login_qr.dart';
import '../plugins/miyoushe_webview.dart';
import '../ui/sp_infobar.dart';

/// 测试页面
class AppDevPage extends ConsumerStatefulWidget {
  /// 构造函数
  const AppDevPage({super.key});

  @override
  ConsumerState<AppDevPage> createState() => _AppDevPageState();
}

/// 测试页面状态
class _AppDevPageState extends ConsumerState<AppDevPage> {
  MysControllerWin? controller;

  final SprBbsApiLoginQr api = SprBbsApiLoginQr();

  /// 二维码数据
  String qrData = '';

  /// 二维码ticket
  String qrTicket = '';

  /// 创建新窗口
  Future<void> createNewWindow() async {
    controller = await MysClientWin.createRecords(context);
    if (mounted) await controller!.show(context);
  }

  /// 刷新二维码
  Future<void> refreshQr(BuildContext context) async {
    var resp = await api.getLoginQr();
    if (resp.retcode != 0) {
      if (context.mounted) await SpInfobar.bbs(context, resp);
      return;
    }
    var data = resp.data as BbsLoginQrGetQrData;
    qrData = data.url;
    qrTicket = data.ticket;
    if (mounted) setState(() {});
  }

  /// 获取二维码状态
  Future<void> getQrStatus(BuildContext context) async {
    if (qrTicket.isEmpty) {
      if (context.mounted) await SpInfobar.warn(context, '请先刷新二维码');
      return;
    }
    var resp = await api.getQRStatus(qrTicket);
    if (resp.retcode != 0) {
      if (context.mounted) await SpInfobar.bbs(context, resp);
      return;
    }
    var data = resp.data as BbsLoginQrStatData;
    debugPrint(data.toJson().toString());
  }

  /// 构建函数
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Test Page')),
      content: Center(
        child: Column(
          children: [
            IconButton(
              icon: const Icon(FluentIcons.f12_dev_tools),
              onPressed: createNewWindow,
            ),
            IconButton(
              icon: const Icon(FluentIcons.refresh),
              onPressed: () async => await refreshQr(context),
            ),
            IconButton(
              icon: const Icon(FluentIcons.q_r_code),
              onPressed: () async => await getQrStatus(context),
            ),
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.sp,
            ),
          ],
        ),
      ),
    );
  }
}

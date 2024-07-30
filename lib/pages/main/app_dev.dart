// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/device/bbs_device_model.dart';
import '../../request/bbs/bbs_api_device.dart';
import '../../ui/sp_infobar.dart';
import '../../widgets/bbs/bbs_infobar.dart';

/// 测试页面
class AppDevPage extends ConsumerStatefulWidget {
  /// 构造函数
  const AppDevPage({super.key});

  @override
  ConsumerState<AppDevPage> createState() => _AppDevPageState();
}

/// 测试页面状态
class _AppDevPageState extends ConsumerState<AppDevPage> {
  @override
  void initState() {
    super.initState();
  }

  /// 应用设置数据库
  final sqlite = SpsAppConfig();

  /// 测试设备指纹获取
  Widget buildDeviceFpTest(BuildContext context) {
    return Button(
      child: const Text('获取设备指纹'),
      onPressed: () async {
        var bbsApiDevice = SprBbsApiDevice();
        var deviceLocal = await sqlite.readDevice();
        var resp = await bbsApiDevice.getDeviceFp();
        if (resp.retcode != 0) {
          if (context.mounted) {
            await BbsInfobar.showResp(context, resp);
          }
          return;
        }
        var deviceData = resp.data as BbsDeviceModelData;
        if (deviceData.code != 200) {
          var message = '[${deviceData.code}] ${deviceData.message}';
          if (context.mounted) {
            await SpInfobar.error(context, message);
          }
          return;
        }
        var deviceFp = deviceData.deviceFp;
        if (context.mounted) {
          if (deviceLocal.deviceFp != deviceFp) {
            await SpInfobar.info(
              context,
              '更新设备指纹: ${deviceLocal.deviceFp} -> $deviceFp',
            );
          } else {
            await SpInfobar.success(context, '设备指纹: $deviceFp');
          }
        }
        deviceLocal.deviceFp = deviceFp;
        await sqlite.writeDevice(deviceLocal);
      },
    );
  }

  /// 测试 WebView
  Widget buildWebviewTest() {
    return const SizedBox(child: Text('Test'));
  }

  /// 构建函数
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Test Page')),
      content: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: <Widget>[
            buildDeviceFpTest(context),
          ],
        ),
      ),
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:macos_ui/macos_ui.dart';

class AppConfigDeviceWidget extends StatefulWidget {
  const AppConfigDeviceWidget({super.key});

  @override
  State<AppConfigDeviceWidget> createState() => _AppConfigDeviceWidgetState();
}

class _AppConfigDeviceWidgetState extends State<AppConfigDeviceWidget> {
  /// 设备信息
  MacOsDeviceInfo? deviceInfo;

  /// webview version
  String? webviewVersion;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      deviceInfo = await DeviceInfoPlugin().macOsInfo;
      if (mounted) setState(() {});
    });
  }

  /// 构建设备信息
  Widget buildOSInfo(MacOsDeviceInfo dim) {
    return MacosListTile(
      leading: const MacosIcon(Icons.desktop_mac),
      title: const Text('MacOS'),
      subtitle:
          Text('${dim.majorVersion}.${dim.minorVersion}.${dim.patchVersion}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (deviceInfo == null) {
      return const MacosListTile(
        leading: Icon(Icons.clear),
        title: Text('无法获取设备信息'),
      );
    }
    return buildOSInfo(deviceInfo!);
  }
}

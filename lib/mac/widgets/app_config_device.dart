// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:webview_windows/webview_windows.dart';

class AppConfigDeviceWidget extends StatefulWidget {
  const AppConfigDeviceWidget({super.key});

  @override
  State<AppConfigDeviceWidget> createState() => _AppConfigDeviceWidgetState();
}

class _AppConfigDeviceWidgetState extends State<AppConfigDeviceWidget> {
  /// 设备信息(Windows)
  WindowsDeviceInfo? deviceInfoWin;

  /// 设备信息(macos)
  MacOsDeviceInfo? deviceInfoMac;

  /// webview version
  String? webviewVersion;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (defaultTargetPlatform == TargetPlatform.windows) {
        deviceInfoWin = await DeviceInfoPlugin().windowsInfo;
        webviewVersion = await WebviewController.getWebViewVersion();
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        deviceInfoMac = await DeviceInfoPlugin().macOsInfo;
      }
      if (mounted) setState(() {});
    });
  }

  /// 构建设备信息(Windows)
  Widget buildOSInfoWin(WindowsDeviceInfo diw) {
    return ListTile(
      leading: const MacosIcon(CupertinoIcons.desktopcomputer),
      title: const Text('操作系统'),
      subtitle: Text(
        'Windows ${diw.displayVersion} '
        '${diw.majorVersion}.${diw.minorVersion}.${diw.buildNumber}'
        '(${diw.buildLab})',
      ),
    );
  }

  /// 构建设备信息(macos)
  Widget buildOSInfoMac(MacOsDeviceInfo dim) {
    return ListTile(
      leading: const MacosIcon(CupertinoIcons.desktopcomputer),
      title: const Text('MacOS'),
      subtitle:
          Text('${dim.majorVersion}.${dim.minorVersion}.${dim.patchVersion}'),
    );
  }

  /// 构建设备信息(Windows)
  Widget buildDeviceInfoWin(WindowsDeviceInfo diw) {
    return ListTile(
      leading: const MacosIcon(CupertinoIcons.desktopcomputer),
      title: Text('设备 ${diw.computerName} ${diw.productId}'),
      subtitle: Text(
        '标识符 ${diw.deviceId.substring(1, diw.deviceId.length - 1)}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((defaultTargetPlatform == TargetPlatform.windows &&
            deviceInfoWin == null) ||
        (defaultTargetPlatform == TargetPlatform.macOS &&
            deviceInfoMac == null)) {
      return const ListTile(
        leading: Icon(CupertinoIcons.clear_circled_solid),
        title: Text('无法获取设备信息'),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return ExpansionTile(
        leading: const Icon(CupertinoIcons.desktopcomputer),
        title: Text(deviceInfoWin!.productName),
        children: [buildOSInfoWin(deviceInfoWin!)],
      );
    }
    return ExpansionTile(
      leading: const Icon(CupertinoIcons.desktopcomputer),
      title: Text(deviceInfoMac!.computerName),
      children: [buildOSInfoMac(deviceInfoMac!)],
    );
  }
}

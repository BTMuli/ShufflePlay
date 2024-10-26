// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart' as mdi;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import '../app_icon.dart';

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
      if(defaultTargetPlatform == TargetPlatform.windows) {
        deviceInfoWin = await DeviceInfoPlugin().windowsInfo;
        webviewVersion = await WebviewController.getWebViewVersion();
      } else if(defaultTargetPlatform == TargetPlatform.macOS) {
        deviceInfoMac = await DeviceInfoPlugin().macOsInfo;
      }
      if (mounted) setState(() {});
    });
  }

  /// 构建设备信息(Windows)
  Widget buildOSInfoWin(WindowsDeviceInfo diw) {
    return ListTile(
      leading: const Icon(FluentIcons.desktop_flow),
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
      leading: Icon(mdi.MdiIcons.apple),
      title: const Text('MacOS'),
      subtitle: Text(
        '${dim.majorVersion}.${dim.minorVersion}.${dim.patchVersion}'
      ),
    );
  }

  /// 构建设备信息(Windows)
  Widget buildDeviceInfoWin(WindowsDeviceInfo diw) {
    return ListTile(
      leading: Icon(mdi.MdiIcons.microsoftWindows),
      title: Text('设备 ${diw.computerName} ${diw.productId}'),
      subtitle: Text(
        '标识符 ${diw.deviceId.substring(1, diw.deviceId.length - 1)}',
      ),
    );
  }

  /// 构建webview信息
  Widget buildWebviewInfo() {
    return ListTile(
      leading: const Icon(FluentIcons.edge_logo),
      title: const Text('Webview2Runtime'),
      subtitle: Text(webviewVersion ?? '未知版本'),
      trailing: IconButton(
        icon: SPIcon(FluentIcons.download),
        onPressed: () async {
          await launchUrlString(
            'https://developer.microsoft.com/microsoft-edge/webview2/',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if ((defaultTargetPlatform == TargetPlatform.windows && deviceInfoWin == null) ||
        (defaultTargetPlatform == TargetPlatform.macOS && deviceInfoMac == null)) {
      return ListTile(
        leading: const Icon(FluentIcons.error),
        title: const Text('无法获取设备信息'),
      );
    }
    if(defaultTargetPlatform == TargetPlatform.windows) {
      return Expander(
        leading: Icon(mdi.MdiIcons.microsoftWindows),
        header: Text(deviceInfoWin!.productName),
        content: Column(
          children: [
            buildOSInfoWin(deviceInfoWin!),
            buildWebviewInfo(),
          ],
        ),
      );
    }
    return Expander(
      leading: Icon(mdi.MdiIcons.appleIcloud),
      header: Text(deviceInfoMac!.computerName),
      content: buildOSInfoMac(deviceInfoMac!)
    );
  }
}

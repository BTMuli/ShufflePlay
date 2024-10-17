// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
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
  /// 设备信息
  WindowsDeviceInfo? deviceInfo;

  /// webview version
  String? webviewVersion;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      deviceInfo = await DeviceInfoPlugin().windowsInfo;
      webviewVersion = await WebviewController.getWebViewVersion();
      if (mounted) setState(() {});
    });
  }

  /// 构建设备信息
  Widget buildOSInfo(WindowsDeviceInfo diw) {
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

  /// 构建设备信息
  Widget buildDeviceInfo(WindowsDeviceInfo diw) {
    return ListTile(
      leading: const Icon(FluentIcons.devices2),
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
    if (deviceInfo == null) {
      return ListTile(
        leading: const Icon(FluentIcons.error),
        title: const Text('无法获取设备信息'),
      );
    }
    return Expander(
      leading: const Icon(FluentIcons.user_window),
      header: Text(deviceInfo!.productName),
      content: Column(
        children: [
          buildOSInfo(deviceInfo!),
          buildDeviceInfo(deviceInfo!),
          buildWebviewInfo(),
        ],
      ),
    );
  }
}

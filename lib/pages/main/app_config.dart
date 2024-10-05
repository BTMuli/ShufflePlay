// Flutter imports:
import 'package:flutter/material.dart' as material;

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_windows/webview_windows.dart';

// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/device/bbs_device_model.dart';
import '../../models/database/app/app_config_model.dart';
import '../../request/bbs/bbs_api_device.dart';
import '../../store/app/app_config.dart';
import '../../ui/sp_infobar.dart';
import '../../utils/get_app_theme.dart';
import '../../widgets/app/app_config_game.dart';
import '../../widgets/app/app_config_user.dart';
import '../../widgets/bbs/bbs_infobar.dart';

class AppConfigPage extends ConsumerStatefulWidget {
  const AppConfigPage({super.key});

  @override
  ConsumerState<AppConfigPage> createState() => _AppConfigPageState();
}

class _AppConfigPageState extends ConsumerState<AppConfigPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  /// 应用信息
  PackageInfo? packageInfo;

  /// 当前主题
  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  /// 当前主题色
  AccentColor get curAccentColor =>
      ref.watch(appConfigStoreProvider).accentColor;

  /// 设备信息
  WindowsDeviceInfo? deviceInfo;

  /// 设备指纹
  AppConfigModelDevice? get deviceLocal =>
      ref.watch(appConfigStoreProvider).device;

  /// 应用配置数据库
  final sqliteAppConfig = SpsAppConfig();

  /// webview version
  String? webviewVersion;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      packageInfo = await PackageInfo.fromPlatform();
      deviceInfo = await DeviceInfoPlugin().windowsInfo;
      webviewVersion = await WebviewController.getWebViewVersion();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 构建设备信息
  Widget buildDeviceInfo(WindowsDeviceInfo? diw) {
    if (diw == null) return const Text('无法获取设备信息');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Expander(
        leading: const Icon(material.Icons.laptop_windows),
        header: Text(diw.productName),
        content: Column(
          children: [
            ListTile(
              leading: const Icon(material.Icons.desktop_windows_outlined),
              title: const Text('操作系统'),
              subtitle: Text(
                'Windows ${diw.displayVersion} '
                '${diw.majorVersion}.${diw.minorVersion}.${diw.buildNumber}'
                '(${diw.buildLab})',
              ),
            ),
            ListTile(
              leading: const Icon(material.Icons.devices_outlined),
              title: Text('设备 ${diw.computerName} ${diw.productId}'),
              subtitle: Text(
                '标识符 ${diw.deviceId.substring(1, diw.deviceId.length - 1)}',
              ),
            ),
            ListTile(
              leading: const Icon(material.Icons.web_asset_outlined),
              title: const Text('Webview2Runtime'),
              subtitle: Text(webviewVersion ?? '未知版本'),
              trailing: IconButton(
                icon: Icon(
                  FluentIcons.download,
                  color: FluentTheme.of(context).accentColor,
                ),
                onPressed: () async {
                  await launchUrlString(
                    'https://developer.microsoft.com/microsoft-edge/webview2/',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建设备指纹信息
  Widget buildFpInfo(BuildContext context, AppConfigModelDevice device) {
    return ListTile(
      leading: const Icon(material.Icons.fingerprint_outlined),
      title: Text('设备指纹 ${device.deviceFp}'),
      subtitle: Text('设备信息 ${device.deviceName}(${device.model})'),
      trailing: Button(
        child: const Text('更新'),
        onPressed: () async {
          var bbsApiDevice = SprBbsApiDevice();
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
          if (device.deviceFp != deviceFp) {
            device.deviceFp = deviceFp;
            await ref.read(appConfigStoreProvider.notifier).setDevice(device);
            if (context.mounted) {
              await SpInfobar.info(
                context,
                '更新设备指纹: ${device.deviceFp} -> $deviceFp',
              );
            }
            return;
          }
          if (context.mounted) {
            await SpInfobar.success(context, '设备指纹: $deviceFp');
          }
        },
      ),
    );
  }

  /// 构建主题切换
  Widget buildThemeSwitch(BuildContext context) {
    var themes = getThemeModeConfigList();
    var curTheme = getThemeConfig(curThemeMode);
    return ListTile(
      leading: Icon(curTheme.icon),
      title: const Text('应用主题'),
      subtitle: Text('当前：${curTheme.label}'),
      trailing: DropDownButton(
        title: Text(curTheme.label),
        items: [
          for (var theme in themes)
            MenuFlyoutItem(
              text: Text(theme.label),
              leading: Icon(theme.icon),
              onPressed: () async {
                await ref
                    .read(appConfigStoreProvider.notifier)
                    .setThemeMode(theme.cur);
              },
              selected: curThemeMode == theme.cur,
              trailing: curThemeMode == theme.cur
                  ? const Icon(material.Icons.check)
                  : null,
            ),
        ],
      ),
    );
  }

  /// 构建主题色切换的Flyout
  Widget buildAccentColorFlyout(BuildContext context) {
    if (curThemeMode == ThemeMode.system) {
      return const Text('系统主题下无法设置主题色');
    }
    return Wrap(
      runSpacing: 8.h,
      spacing: 8.w,
      children: [
        for (var color in Colors.accentColors)
          Button(
            autofocus: curAccentColor == color,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: () async {
              await ref
                  .read(appConfigStoreProvider.notifier)
                  .setAccentColor(color);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Container(color: color, width: 32.w, height: 32.h),
          ),
      ],
    );
  }

  /// 构建主题色切换
  Widget buildAccentColorSwitch() {
    return ListTile(
      leading: const Icon(FluentIcons.color),
      title: const Text('主题色'),
      subtitle: Text(
        curAccentColor.value.toRadixString(16),
        style: TextStyle(color: Color(curAccentColor.value)),
      ),
      trailing: SplitButton(
        flyout: FlyoutContent(
          constraints: BoxConstraints(maxWidth: 200.w),
          child: buildAccentColorFlyout(context),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(curAccentColor.value),
            borderRadius: BorderRadius.circular(4),
          ),
          width: 32.w,
          height: 32.h,
        ),
      ),
    );
  }

  /// 构建应用信息
  Widget buildAppInfo(PackageInfo pkg, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Expander(
        initiallyExpanded: true,
        leading: const Icon(material.Icons.settings_applications_outlined),
        header: const Text('应用信息'),
        content: Column(children: [
          ListTile(
            leading: const Icon(material.Icons.info_outline),
            title: const Text('ShufflePlay'),
            subtitle: Text('${pkg.version}+${pkg.buildNumber}'),
            trailing: IconButton(
              icon: Icon(
                FluentIcons.edge_logo,
                color: Color(curAccentColor.value),
              ),
              onPressed: () async {
                await launchUrlString('https://github.com/BTMuli/ShufflePlay');
              },
            ),
          ),
          if (deviceLocal != null) buildFpInfo(context, deviceLocal!),
          buildThemeSwitch(context),
          buildAccentColorSwitch(),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldPage(
      content: ListView(children: [
        if (packageInfo != null) buildAppInfo(packageInfo!, context),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const AppConfigGameWidget(),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: const AppConfigUserWidget(),
        ),
        SizedBox(height: 10.h),
        buildDeviceInfo(deviceInfo)
      ]),
    );
  }
}

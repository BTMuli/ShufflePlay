// Flutter imports:
import 'package:flutter/material.dart' as material;

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import '../../../models/bbs/device/bbs_device_model.dart';
import '../../../models/database/app/app_config_model.dart';
import '../../../request/bbs/bbs_api_device.dart';
import '../../../store/app/app_config.dart';
import '../../../tools/log_tool.dart';
import '../../../ui/sp_infobar.dart';
import '../../../utils/get_app_theme.dart';
import '../../bbs/bbs_infobar.dart';
import '../app_icon.dart';

class AppConfigInfoWidget extends ConsumerStatefulWidget {
  const AppConfigInfoWidget({super.key});

  @override
  ConsumerState<AppConfigInfoWidget> createState() =>
      _AppConfigInfoWidgetState();
}

class _AppConfigInfoWidgetState extends ConsumerState<AppConfigInfoWidget> {
  /// 应用信息
  PackageInfo? packageInfo;

  /// 设备信息
  WindowsDeviceInfo? deviceInfo;

  /// deviceApi
  final SprBbsApiDevice apiDevice = SprBbsApiDevice();

  /// fileTool
  final SPLogTool logTool = SPLogTool();

  /// 当前主题
  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  /// 设备指纹
  AppConfigModelDevice? get deviceLocal =>
      ref.watch(appConfigStoreProvider).device;

  /// 当前主题色
  AccentColor get curAccentColor =>
      ref.watch(appConfigStoreProvider).accentColor;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      packageInfo = await PackageInfo.fromPlatform();
      deviceInfo = await DeviceInfoPlugin().windowsInfo;
      if (mounted) setState(() {});
    });
  }

  /// 刷新设备信息
  Future<void> refreshDevice() async {
    var resp = await apiDevice.getDeviceFp();
    if (resp.retcode != 0) {
      if (mounted) await BbsInfobar.showResp(context, resp);
      return;
    }
    var deviceData = resp.data as BbsDeviceModelData;
    if (deviceData.code != 200) {
      var message = '[${deviceData.code}] ${deviceData.message}';
      if (mounted) await SpInfobar.error(context, message);
      return;
    }
    var deviceFp = deviceData.deviceFp;
    if (deviceLocal!.deviceFp != deviceFp) {
      deviceLocal!.deviceFp = deviceFp;
      await ref.read(appConfigStoreProvider.notifier).setDevice(deviceLocal!);
      if (mounted) {
        await SpInfobar.info(
          context,
          '更新设备指纹: ${deviceLocal!.deviceFp} -> $deviceFp',
        );
      }
      return;
    }
    if (mounted) await SpInfobar.success(context, '设备指纹: $deviceFp');
  }

  /// 构建应用信息
  Widget buildAppInfo() {
    return ListTile(
      leading: const Icon(FluentIcons.info),
      title: const Text('ShufflePlay'),
      subtitle: Text('版本: ${packageInfo!.version}+${packageInfo!.buildNumber}'),
      trailing: IconButton(
        icon: SPIcon(FluentIcons.edge_logo),
        onPressed: () async {
          await launchUrlString('https://github.com/BTMuli/ShufflePlay');
        },
      ),
    );
  }

  /// 构建设备信息
  Widget buildDeviceInfo() {
    return ListTile(
      leading: const Icon(FluentIcons.fingerprint),
      title: Text('设备指纹 ${deviceLocal!.deviceFp}'),
      subtitle: Text('设备信息 ${deviceLocal!.deviceName}(${deviceLocal!.model})'),
      trailing: IconButton(
        icon: SPIcon(FluentIcons.refresh),
        onPressed: refreshDevice,
      ),
    );
  }

  /// 构建主题信息
  Widget buildThemeInfo() {
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
              leading: curThemeMode == theme.cur
                  ? SPIcon(theme.icon)
                  : Icon(theme.icon),
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

  /// 构建主题色信息
  Widget buildAccentColorInfo() {
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
          child: buildAccentColorFlyout(),
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

  /// 构建主题色切换的Flyout
  Widget buildAccentColorFlyout() {
    if (curThemeMode == ThemeMode.system) return const Text('系统主题下无法设置主题色');
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
              if (mounted) Navigator.of(context).pop();
            },
            child: Container(color: color, width: 32.w, height: 32.h),
          ),
      ],
    );
  }

  /// 构建日志信息
  Widget buildLogInfo() {
    return ListTile(
      leading: const Icon(FluentIcons.folder_search),
      title: const Text('日志'),
      subtitle: Text(logTool.logDir),
      trailing: IconButton(
        icon: SPIcon(FluentIcons.folder_open),
        onPressed: logTool.openLogDir,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: true,
      leading: const Icon(FluentIcons.app_icon_default),
      header: const Text('应用信息'),
      content: Column(
        children: [
          if (packageInfo != null) buildAppInfo(),
          if (deviceLocal != null) buildDeviceInfo(),
          buildThemeInfo(),
          buildAccentColorInfo(),
          buildLogInfo(),
        ],
      ),
    );
  }
}

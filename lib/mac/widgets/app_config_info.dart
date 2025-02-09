// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import '../../../../models/bbs/device/bbs_device_model.dart';
import '../../../../models/database/app/app_config_model.dart';
import '../../../../request/bbs/bbs_api_device.dart';
import '../../../../shared/tools/log_tool.dart';
import '../../../../shared/utils/get_app_theme.dart';
import '../../models/app/enum_extension.dart';
import '../models/ui_model.dart';
import '../store/app_config.dart';
import '../ui/sp_infobar.dart';

class AppConfigInfoWidget extends ConsumerStatefulWidget {
  const AppConfigInfoWidget({super.key});

  @override
  ConsumerState<AppConfigInfoWidget> createState() =>
      _AppConfigInfoWidgetState();
}

class _AppConfigInfoWidgetState extends ConsumerState<AppConfigInfoWidget> {
  /// 应用信息
  PackageInfo? packageInfo;

  /// deviceApi
  final SprBbsApiDevice apiDevice = SprBbsApiDevice();

  /// fileTool
  final SPLogTool logTool = SPLogTool();

  /// 当前主题
  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  SpAppThemeConfig get curTheme => getThemeConfig(curThemeMode);

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
      if (mounted) setState(() {});
    });
  }

  /// 刷新设备信息
  Future<void> refreshDevice() async {
    var resp = await apiDevice.getDeviceFp();
    if (resp.retcode != 0) {
      if (mounted) await SpInfobar.bbs(context, resp);
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
        await SpInfobar.success(
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
    return MacosListTile(
      leading: Image.asset(
        'assets/images/ShufflePlayMini.png',
        width: 24,
        height: 24,
      ),
      title: const Text('ShufflePlay'),
      subtitle: Text('版本: ${packageInfo!.version}+${packageInfo!.buildNumber}'),
    );
  }

  /// 构建设备信息
  Widget buildDeviceInfo() {
    return MacosListTile(
      leading: const Icon(Icons.fingerprint),
      title: Row(
        children: [
          const Text('设备指纹'),
          MacosTooltip(
            message: '刷新设备指纹',
            child: MacosIconButton(
              icon: const Icon(Icons.refresh),
              onPressed: refreshDevice,
            ),
          ),
        ],
      ),
      subtitle: Text(deviceLocal!.deviceFp),
    );
  }

  /// 构建主题项
  MacosPopupMenuItem<ThemeMode> buildThemeItem(SpAppThemeConfig theme) {
    return MacosPopupMenuItem<ThemeMode>(
      onTap: () async =>
          await ref.read(appConfigStoreProvider).setThemeMode(theme.cur),
      value: theme.cur,
      child: Text(theme.label),
    );
  }

  /// 构建主题信息
  Widget buildThemeInfo() {
    var curTheme = getThemeConfig(curThemeMode);
    return MacosListTile(
      leading: Icon(curTheme.icon),
      title: Row(
        children: [
          const Text('主题'),
          const SizedBox(width: 8),
          MacosPopupButton<ThemeMode>(
            hint: Text(curTheme.label),
            items: getThemeModeConfigList().map(buildThemeItem).toList(),
            value: curThemeMode,
            onChanged: (val) {},
          ),
        ],
      ),
      subtitle: Text('当前：${curTheme.label}'),
    );
  }

  /// 构建主题色信息
  Widget buildAccentColorInfo() {
    return MacosListTile(
      leading: const Icon(Icons.color_lens),
      title: Row(
        children: [
          const Text('主题色'),
          const SizedBox(width: 8),
          MacosPopupButton<AccentColor>(
            hint: Container(
              decoration: BoxDecoration(
                color: Color(curAccentColor.color.hex),
                borderRadius: BorderRadius.circular(4),
              ),
              width: 32,
              height: 32,
            ),
            items: getAccentColors().map(buildColorItem).toList(),
            onChanged: (value) {},
            value: curAccentColor,
          ),
        ],
      ),
      subtitle: Text(
        curAccentColor.color.hex.toRadixString(16),
        style: TextStyle(color: Color(curAccentColor.color.hex)),
      ),
    );
  }

  /// 构建主题色切换的Flyout
  MacosPopupMenuItem<AccentColor> buildColorItem(AccentColor color) {
    return MacosPopupMenuItem(
      onTap: () async {
        await ref.read(appConfigStoreProvider.notifier).setAccentColor(color);
      },
      value: color,
      child: Container(color: color.color, width: 32, height: 32),
    );
  }

  /// 构建日志信息
  Widget buildLogInfo() {
    return MacosListTile(
      leading: const MacosIcon(Icons.folder_special),
      title: const Text('日志'),
      onClick: logTool.openLogDir,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (packageInfo != null) buildAppInfo(),
        if (deviceLocal != null) buildDeviceInfo(),
        buildThemeInfo(),
        buildAccentColorInfo(),
        buildLogInfo(),
      ],
    );
  }
}

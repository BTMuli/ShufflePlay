// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import '../../shared/utils/get_app_theme.dart';
import '../pages/nap_anno.dart';
import '../pages/user_gacha.dart';
import '../store/app_config.dart';

class AppNavWidget extends ConsumerStatefulWidget {
  const AppNavWidget({super.key});

  @override
  ConsumerState<AppNavWidget> createState() => _AppNavWidgetState();
}

class _AppNavWidgetState extends ConsumerState<AppNavWidget> {
  int curIndex = 0;

  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  AccentColor get curColor => ref.watch(appConfigStoreProvider).accentColor;

  PackageInfo? packageInfo;

  final pages = [
    NapAnnoPage(),
    UserGachaPage(),
    if (kDebugMode) Text('测试页'),
    Text('设置'),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {});
    });
  }

  List<PlatformMenuItem> buildMenus() {
    return [
      PlatformMenu(label: 'ShufflePlay', menus: [
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.quit),
      ]),
      PlatformMenu(label: 'View', menus: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.toggleFullScreen,
        )
      ]),
      PlatformMenu(label: 'Window', menus: [
        PlatformProvidedMenuItem(
          type: PlatformProvidedMenuItemType.minimizeWindow,
        ),
        PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.zoomWindow),
      ]),
    ];
  }

  List<SidebarItem> buildSidebarItems() {
    return [
      SidebarItem(
        leading: Icon(CupertinoIcons.news),
        label: Text('公告'),
      ),
      SidebarItem(
        leading: Icon(CupertinoIcons.music_note),
        label: Text('调频记录'),
      ),
      if (kDebugMode)
        SidebarItem(
          leading: Icon(CupertinoIcons.wrench),
          label: Text('测试页'),
        ),
      SidebarItem(
        leading: Icon(CupertinoIcons.settings),
        label: Text('设置'),
      ),
    ];
  }

  Widget buildSidebarTop(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'ShufflePlay',
          style: MacosTheme.of(context).typography.largeTitle,
        ),
        if (packageInfo != null)
          Text(
            'Version ${packageInfo!.version}',
            style: MacosTheme.of(context).typography.body,
          ),
      ],
    );
  }

  Widget buildSidebarBottom(BuildContext context) {
    var themeConfig = getThemeConfig(curThemeMode);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16.0),
        Text(
          '© 2024 BTMuli',
          style: MacosTheme.of(context).typography.body,
        ),
        const SizedBox(height: 16.0),
        MacosIconButton(
          icon: MacosIcon(themeConfig.icon),
          onPressed: () async => await ref
              .read(appConfigStoreProvider)
              .setThemeMode(themeConfig.next),
        ),
      ],
    );
  }

  Widget buildSidebar(
    BuildContext context,
    ScrollController controller,
  ) {
    return SidebarItems(
      currentIndex: curIndex,
      scrollController: controller,
      itemSize: SidebarItemSize.large,
      onChanged: (i) => setState(() => curIndex = i),
      items: buildSidebarItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: defaultTargetPlatform == TargetPlatform.macOS ? buildMenus() : [],
      child: MacosWindow(
        sidebar: Sidebar(
          top: buildSidebarTop(context),
          minWidth: 150.w,
          builder: buildSidebar,
          isResizable: false,
          bottom: buildSidebarBottom(context),
        ),
        disableWallpaperTinting: true,
        child: pages[curIndex],
      ),
    );
  }
}

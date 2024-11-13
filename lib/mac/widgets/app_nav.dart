// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import '../pages/nap_anno.dart';
import '../store/app_config.dart';

class AppNavWidget extends ConsumerStatefulWidget {
  const AppNavWidget({super.key});

  @override
  ConsumerState<AppNavWidget> createState() => _AppNavWidgetState();
}

class _AppNavWidgetState extends ConsumerState<AppNavWidget>
    with AutomaticKeepAliveClientMixin {
  int curIndex = 0;

  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  PackageInfo? packageInfo;

  @override
  bool get wantKeepAlive => false;

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
      SidebarItem(leading: Icon(FluentIcons.home), label: Text('游戏公告')),
      SidebarItem(
        leading: Icon(FluentIcons.auto_enhance_on),
        label: Text('调频记录'),
      ),
      if (kDebugMode)
        SidebarItem(leading: Icon(FluentIcons.test_beaker), label: Text('测试页'))
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

  Widget getChild() {
    switch (curIndex) {
      case 0:
        return const NapAnnoPage();
      case 1:
        return Text('调频记录');
      case 2:
        return Text('测试页');
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        backgroundColor: Colors.transparent,
        child: getChild(),
      ),
    );
  }
}

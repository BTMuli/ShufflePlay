// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import '../../pages/main/app_config.dart';
import '../../pages/main/app_dev.dart';
import '../../pages/user/user_gacha.dart';
import '../../store/app/app_config.dart';
import '../../ui/sp_infobar.dart';
import '../../utils/get_app_theme.dart';

class AppNavWidget extends ConsumerStatefulWidget {
  const AppNavWidget({super.key});

  @override
  ConsumerState<AppNavWidget> createState() => _AppNavWidgetState();
}

class _AppNavWidgetState extends ConsumerState<AppNavWidget>
    with AutomaticKeepAliveClientMixin {
  /// 当前索引
  int curIndex = 0;

  /// 当前主题模式
  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  /// flyout
  final FlyoutController flyout = FlyoutController();

  /// 测试的时候置为false
  @override
  bool get wantKeepAlive => false;

  /// dispose
  /// dispose
  @override
  void dispose() {
    flyout.dispose();
    super.dispose();
  }

  /// 获取导航项
  List<PaneItem> getNavItems(BuildContext context) {
    return [
      PaneItem(
        icon: const Icon(FluentIcons.auto_enhance_on),
        title: const Text('调频记录'),
        body: const UserGachaPage(),
      ),
      if (kDebugMode)
        PaneItem(
          icon: const Icon(FluentIcons.test_beaker),
          title: const Text('测试页'),
          body: const AppDevPage(),
        ),
    ];
  }

  /// 展示设置flyout
  void showOptionsFlyout() {
    flyout.showFlyout(
      barrierDismissible: true,
      dismissOnPointerMoveAway: false,
      dismissWithEsc: true,
      builder: (context) => MenuFlyout(
        items: [
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.reset_device),
            text: const Text('重置窗口大小'),
            onPressed: () async {
              var size = await windowManager.getSize();
              var target = const Size(1280, 720);
              if (size == target) {
                if (context.mounted) await SpInfobar.warn(context, '无需重置大小！');
                return;
              }
              await windowManager.setSize(target);
              if (context.mounted) {
                await SpInfobar.success(context, '已成功重置窗口大小！');
              }
            },
          ),
          MenuFlyoutItem(
            leading: const Icon(FluentIcons.pinned_solid),
            text: const Text('窗口置顶/取消置顶'),
            onPressed: () async {
              var isAlwaysOnTop = await windowManager.isAlwaysOnTop();
              await windowManager.setAlwaysOnTop(!isAlwaysOnTop);
              var str = isAlwaysOnTop ? '取消置顶' : '置顶';
              if (context.mounted) {
                await SpInfobar.success(context, '$str成功');
              }
            },
          ),
        ],
      ),
    );
  }

  /// 构建主题模式项
  PaneItemAction buildThemeModeItem() {
    var config = getThemeConfig(curThemeMode);
    return PaneItemAction(
      icon: Icon(config.icon),
      title: Text(config.label),
      onTap: () async {
        await ref.read(appConfigStoreProvider).setThemeMode(config.next);
      },
    );
  }

  /// 获取底部导航
  List<PaneItem> getFooterItems() {
    return [
      PaneItemAction(
        icon: FlyoutTarget(
          controller: flyout,
          child: const Icon(FluentIcons.graph_symbol),
        ),
        title: const Text('更多设置'),
        onTap: showOptionsFlyout,
      ),
      buildThemeModeItem(),
      PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text('设置'),
        body: const AppConfigPage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavigationView(
      pane: NavigationPane(
        selected: curIndex,
        onChanged: (index) {
          setState(() {
            curIndex = index;
          });
        },
        displayMode: PaneDisplayMode.compact,
        items: getNavItems(context),
        footerItems: getFooterItems(),
      ),
    );
  }
}

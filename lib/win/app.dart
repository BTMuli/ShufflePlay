// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../mac/widgets/app/app_nav.dart';
import 'store/app_config.dart';

class SPApp extends ConsumerWidget {
  const SPApp({super.key});

  /// 获取主题配置
  FluentThemeData getTheme(BuildContext context, SpAppConfigStore appStore) {
    Brightness brightness;
    switch (appStore.themeMode) {
      case ThemeMode.system:
        brightness = MediaQuery.platformBrightnessOf(context);
        break;
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
    }
    return FluentThemeData(
      brightness: brightness,
      accentColor: appStore.accentColor,
      fontFamily: 'SarasaGothic',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appConfigStore = ref.watch(appConfigStoreProvider);
    return ScreenUtilInit(
      designSize: const Size(1280, 720),
      builder: (_, child) {
        return FluentApp(
          title: 'ShufflePlay',
          themeMode: appConfigStore.themeMode,
          theme: getTheme(context, appConfigStore),
          home: const AppNavWidget(),
        );
      },
    );
  }
}

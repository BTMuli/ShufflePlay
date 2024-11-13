// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import 'models/ui_model.dart';
import 'store/app_config.dart';
import 'widgets/app/app_nav.dart';

class SPApp extends ConsumerWidget {
  const SPApp({super.key});

  MacosThemeData getTheme(BuildContext context, SpAppConfigStore appStore) {
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
    return MacosThemeData(
      brightness: brightness,
      accentColor: appStore.accentColor,
      // fontFamily: 'SarasaGothic',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appConfigStore = ref.watch(appConfigStoreProvider);
    return ScreenUtilInit(
      designSize: const Size(1280, 720),
      builder: (_, child) {
        return MacosApp(
          title: 'ShufflePlay',
          themeMode: appConfigStore.themeMode,
          theme: getTheme(context, appConfigStore),
          color: appConfigStore.accentColor.color,
          home: const AppNavWidget(),
        );
      },
    );
  }
}

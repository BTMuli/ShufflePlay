// Package imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import 'models/ui_model.dart';
import 'store/app_config.dart';
import 'widgets/app_nav.dart';

class SPApp extends ConsumerStatefulWidget {
  const SPApp({super.key});

  @override
  ConsumerState<SPApp> createState() => _SPAppState();
}

class _SPAppState extends ConsumerState<SPApp> {
  AccentColor get curAccentColor =>
      ref.watch(appConfigStoreProvider).accentColor;

  ThemeMode get curThemeMode => ref.watch(appConfigStoreProvider).themeMode;

  MacosThemeData getTheme(BuildContext context, SpAppConfigStore appStore) {
    Brightness brightness;
    switch (appStore.themeMode) {
      case ThemeMode.system:
        brightness = MediaQuery.platformBrightnessOf(context);
        break;
      case ThemeMode.light:
        brightness = Brightness.light;
        return MacosThemeData.light(accentColor: appStore.accentColor);
      case ThemeMode.dark:
        brightness = Brightness.dark;
        return MacosThemeData.dark(accentColor: appStore.accentColor);
    }
    if (brightness == Brightness.light) {
      return MacosThemeData.light(accentColor: appStore.accentColor);
    } else {
      return MacosThemeData.dark(accentColor: appStore.accentColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1280, 720),
      builder: (_, child) {
        return MacosApp(
          title: 'ShufflePlay',
          themeMode: curThemeMode,
          theme: getTheme(context, ref.watch(appConfigStoreProvider)),
          color: curAccentColor.color,
          home: AppNavWidget(),
        );
      },
    );
  }
}

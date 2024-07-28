// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'widgets/app/app_nav.dart';

class SPApp extends StatelessWidget {
  const SPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1600, 900),
      child: MaterialApp(
        title: 'ShufflePlay',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const AppNavWidget(),
      ),
    );
  }
}

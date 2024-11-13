// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../widgets/app_config_device.dart';
import '../widgets/app_config_game.dart';
import '../widgets/app_config_info.dart';
import '../widgets/app_config_user.dart';

class AppConfigPage extends ConsumerStatefulWidget {
  const AppConfigPage({super.key});

  @override
  ConsumerState<AppConfigPage> createState() => _AppConfigPageState();
}

class _AppConfigPageState extends ConsumerState<AppConfigPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldPage(
      content: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppConfigInfoWidget(),
          ),
          if (defaultTargetPlatform == TargetPlatform.windows) ...[
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const AppConfigGameWidget(),
            )
          ],
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppConfigUserWidget(),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const AppConfigDeviceWidget(),
          ),
        ],
      ),
    );
  }
}

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import '../widgets/app_config_device.dart';
import '../widgets/app_config_info.dart';
import '../widgets/app_config_user.dart';
import '../widgets/app_top.dart';

class AppConfigPage extends StatelessWidget {
  const AppConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [
      AppConfigInfoWidget(),
      AppConfigUserWidget(),
      AppConfigDeviceWidget()
    ];
    return MacosScaffold(
      toolBar: ToolBar(
        title: Text(
          '调频记录',
          style: MacosTheme.of(context).typography.headline,
        ),
        leading: buildTopLeading(context),
      ),
      children: [
        ContentArea(
          builder: (_, __) => Scaffold(
            body: SingleChildScrollView(
              child: ListView.separated(
                itemBuilder: (_, index) => pages[index],
                separatorBuilder: (_, __) => Divider(),
                itemCount: pages.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

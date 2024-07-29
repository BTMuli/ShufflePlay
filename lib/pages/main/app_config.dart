// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

class AppConfigPage extends StatelessWidget {
  const AppConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      header: PageHeader(title: Text('App Config')),
      content: Center(child: Text('App Config Page')),
    );
  }
}

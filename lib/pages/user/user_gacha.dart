// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:file_selector/file_selector.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:json_schema/json_schema.dart';

// Project imports:
import '../../ui/sp_infobar.dart';

class UserGachaPage extends StatefulWidget {
  const UserGachaPage({super.key});

  @override
  State<UserGachaPage> createState() => _UserGachaPageState();
}

class _UserGachaPageState extends State<UserGachaPage> {
  late JsonSchema schema;

  @override
  void initState() {
    super.initState();
    // 读取 lib/source/schema/uigf-4.0-schema.json
    const schemaFile = 'lib/source/schema/uigf-4.0-schema.json';
    Future.microtask(() async {
      schema = await JsonSchema.createFromUrl(schemaFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('调频记录')),
      content: Center(
        child: Button(
          child: const Text('Import UIGFv4 JSON'),
          onPressed: () async {
            const XTypeGroup fileType = XTypeGroup(
              label: 'json',
              extensions: ['json'],
            );
            XFile? file =
                await openFile(acceptedTypeGroups: <XTypeGroup>[fileType]);
            if (file != null) {
              var fileJson = jsonDecode(await file.readAsString());
              var result = schema.validate(fileJson);
              if (result.isValid) {
                if (context.mounted) {
                  await SpInfobar.success(context, 'Valid JSON');
                }
                return;
              }
              for (var error in result.errors) {
                if (context.mounted) {
                  await SpInfobar.error(context, error.message);
                }
              }
            }
          },
        ),
      ),
    );
  }
}

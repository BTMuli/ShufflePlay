// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../store/user/user_bbs.dart';

class AppConfigUserWidget extends ConsumerStatefulWidget {
  const AppConfigUserWidget({super.key});

  @override
  ConsumerState<AppConfigUserWidget> createState() =>
      _AppConfigUserWidgetState();
}

class _AppConfigUserWidgetState extends ConsumerState<AppConfigUserWidget> {
  /// uid
  List<String> get uids => ref.watch(uerBbsStoreProvider).uids;

  /// 当前用户uid
  String? get uid => ref.watch(uerBbsStoreProvider).uid;

  /// 当前用户
  UserBBSModel? get user => ref.watch(uerBbsStoreProvider).user;

  @override
  void initState() {
    super.initState();
  }

  /// 构建空用户
  Widget buildEmptyUser() {
    return Expander(
      initiallyExpanded: true,
      leading: const Icon(FluentIcons.user_warning),
      header: const Text('未登录'),
      trailing: IconButton(
        icon: const Icon(FluentIcons.signin),
        onPressed: () {
          // Navigator.of(context).pushNamed('/login');
        },
      ),
      content: Column(
        children: <Widget>[
          const Text('请登录后查看用户信息'),
          const SizedBox(height: 10),
          IconButton(
            onPressed: () {
              // Navigator.of(context).pushNamed('/login');
            },
            icon: const Icon(FluentIcons.signin),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (uids.isEmpty) return buildEmptyUser();
    return const ListTile(
      leading: Icon(FluentIcons.reminder_person),
      title: Text('用户信息'),
      trailing: Icon(FluentIcons.chevron_right),
    );
  }
}

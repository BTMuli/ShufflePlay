// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  /// 所有用户
  List<UserBBSModel> get users => ref.watch(uerBbsStoreProvider).users;

  @override
  void initState() {
    super.initState();
  }

  /// 添加用户-通过cookie
  Future<void> addUserByCookie() async {
    String input = '';
    await showDialog(
      barrierDismissible: true,
      dismissWithEsc: true,
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: const Text('添加用户'),
          content: SizedBox(
            height: 50.h,
            child: TextBox(
              placeholder: '请输入cookie',
              onChanged: (String value) {
                input = value;
              },
            ),
          ),
          actions: <Widget>[
            Button(
              onPressed: () async {
                // ref.read(uerBbsStoreProvider).addUserByCookie(input);
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
            Button(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
    debugPrint('input: $input');
  }

  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: uids.isEmpty,
      leading: uids.isEmpty
          ? const Icon(FluentIcons.user_warning)
          : const Icon(FluentIcons.group),
      header: uids.isEmpty ? const Text('未登录') : const Text('用户信息'),
      content: Column(
        children: <Widget>[
          for (final UserBBSModel user in users)
            ListTile(
              leading: const Icon(FluentIcons.user_sync),
              title: Text(user.brief?.username ?? '未知用户'),
              subtitle: Text(user.uid),
              trailing: IconButton(
                icon: const Icon(FluentIcons.delete),
                onPressed: () {
                  // ref.read(uerBbsStoreProvider).deleteUser(user.uid);
                },
              ),
            ),
          ListTile(
            leading: const Icon(FluentIcons.add),
            title: const Text('添加用户（通过cookie）'),
            onPressed: () async {
              await addUserByCookie();
            },
            trailing: Tooltip(
              message: '短信验证码登录',
              child: IconButton(
                icon: const Icon(FluentIcons.mobile_angled),
                onPressed: () {
                  // ref.read(uerBbsStoreProvider).addUserByCookie(input);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

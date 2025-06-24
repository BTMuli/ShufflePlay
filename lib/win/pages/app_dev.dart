// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../models/nap/account/nap_account_model.dart';
import '../../request/nap/nap_api_record.dart';
import '../../shared/store/user_bbs.dart';
import '../plugins/miyoushe_webview.dart';
import '../ui/sp_infobar.dart';

/// 测试页面
class AppDevPage extends ConsumerStatefulWidget {
  /// 构造函数
  const AppDevPage({super.key});

  @override
  ConsumerState<AppDevPage> createState() => _AppDevPageState();
}

/// 测试页面状态
class _AppDevPageState extends ConsumerState<AppDevPage> {
  MysControllerWin? controller;

  UserBBSModel? get user => ref.watch(userBbsStoreProvider).user;
  NapAccountModel? get account => ref.watch(userBbsStoreProvider).account;

  final SprNapApiRecord api = SprNapApiRecord();

  /// 创建新窗口
  Future<void> createNewWindow() async {
    controller = await MysClientWin.createRecords(context);
    if (mounted) await controller!.show(context);
  }

  Future<void> testGetAvatarList() async {
    if (user == null || account == null || user!.cookie == null) {
      await SpInfobar.warn(context, '请先登录');
      return;
    }
    var resp = await api.getAvatarDetail(1031, account!, user!.cookie!);
    if (resp.retcode != 0) {
      if (mounted) await SpInfobar.bbs(context, resp);
    }
  }

  /// 构建函数
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Test Page')),
      content: Center(
        child: Column(
          children: [
            IconButton(
              icon: const Icon(FluentIcons.f12_dev_tools),
              onPressed: createNewWindow,
            ),
            IconButton(
              icon: const Icon(FluentIcons.test_add),
              onPressed: testGetAvatarList,
            ),
          ],
        ),
      ),
    );
  }
}

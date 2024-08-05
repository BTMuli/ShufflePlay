// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../../models/nap/token/nap_authkey_model.dart';
import '../../request/nap/nap_api_account.dart';
import '../../request/nap/nap_api_gacha.dart';
import '../../store/user/user_bbs.dart';
import '../../ui/sp_infobar.dart';

/// 测试页面
class AppDevPage extends ConsumerStatefulWidget {
  /// 构造函数
  const AppDevPage({super.key});

  @override
  ConsumerState<AppDevPage> createState() => _AppDevPageState();
}

/// 测试页面状态
class _AppDevPageState extends ConsumerState<AppDevPage> {
  @override
  void initState() {
    super.initState();
  }

  /// 测试 WebView
  Widget buildWebviewTest() {
    return const SizedBox(child: Text('Test'));
  }

  /// 测试生成授权码
  Widget buildGenAuthKeyTest() {
    return Button(
      child: const Text('生成授权码'),
      onPressed: () async {
        var api = SprNapApiAccount();
        var store = ref.watch(userBbsStoreProvider);
        if (store.user == null ||
            store.account == null ||
            store.user!.cookie == null) {
          return;
        }
        var resp = await api.genAuthKey(store.user!.cookie!, store.account!);
        if (resp.retcode != 0) {
          if (mounted) await SpInfobar.bbs(context, resp);
          return;
        }
        var authKeyData = resp.data as NapAuthkeyModelData;
        var authKey = authKeyData.authkey;
        var api2 = SprNapApiGacha();
        var gachaResp = await api2.getGachaLogs(
          store.account!,
          store.user!.cookie!,
          authKey,
        );
        if (gachaResp.retcode != 0) {
          if (mounted) await SpInfobar.bbs(context, gachaResp);
          return;
        }
        if (mounted) await SpInfobar.bbs(context, gachaResp);
        debugPrint('gachaResp: $gachaResp');
      },
    );
  }

  /// 构建函数
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Test Page')),
      content: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: <Widget>[
            buildWebviewTest(),
            SizedBox(height: 20.h),
            buildGenAuthKeyTest(),
          ],
        ),
      ),
    );
  }
}

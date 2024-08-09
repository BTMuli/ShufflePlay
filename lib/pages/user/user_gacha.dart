// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../../database/nap/nap_item_map.dart';
import '../../database/user/user_gacha.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/gacha/nap_gacha_model.dart';
import '../../models/nap/token/nap_authkey_model.dart';
import '../../plugins/Hakushi/hakushi_client.dart';
import '../../plugins/UIGF/models/uigf_enum.dart';
import '../../plugins/UIGF/models/uigf_model.dart';
import '../../plugins/UIGF/uigf_tool.dart';
import '../../request/nap/nap_api_account.dart';
import '../../request/nap/nap_api_gacha.dart';
import '../../store/user/user_bbs.dart';
import '../../tools/file_tool.dart';
import '../../ui/sp_dialog.dart';
import '../../ui/sp_infobar.dart';
import '../../ui/sp_progress.dart';
import '../../widgets/user/user_gacha_view.dart';

class UserGachaPage extends ConsumerStatefulWidget {
  const UserGachaPage({super.key});

  @override
  ConsumerState<UserGachaPage> createState() => _UserGachaPageState();
}

class _UserGachaPageState extends ConsumerState<UserGachaPage> {
  /// uid列表
  List<String> uidList = [];

  /// 当前uid
  String? curUid;

  /// NapItemMap 数据库
  final sqliteMap = SpsNapItemMap();

  /// Hakushi客户端
  final hakushiApi = SprPluginHakushi();

  /// 用户祈愿数据库
  final sqliteUser = SpsUserGacha();

  /// 文件工具
  final fileTool = SPFileTool();

  /// Uigf工具
  final SppUigfTool uigfTool = SppUigfTool();

  /// 进度条
  SpProgressController progress = SpProgressController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await refreshData();
    });
  }

  Future<void> refreshData() async {
    uidList = await sqliteUser.getAllUid();
    if (uidList.isNotEmpty) {
      curUid = uidList.first;
    } else {
      curUid = null;
    }
    if (mounted) setState(() {});
  }

  Future<void> importUigf4Json(BuildContext context) async {
    var filePath = await fileTool.selectFile(context: context);
    if (filePath == null) {
      if (context.mounted) await SpInfobar.warn(context, '未选择文件');
      return;
    }
    var file = await fileTool.readFile(filePath);
    if (file == null) {
      if (context.mounted) await SpInfobar.error(context, '文件读取失败');
      return;
    }
    try {
      jsonDecode(file);
    } catch (e) {
      if (context.mounted) {
        await SpInfobar.error(context, '文件解析失败');
      }
      return;
    }
    var fileJson = jsonDecode(file);
    var result = await uigfTool.validate(fileJson);
    if (!result.isValid) {
      var error = result.errors.first;
      if (context.mounted) {
        await SpInfobar.error(context, '文件解析失败: ${error.message}');
      }
      return;
    }
    if (!context.mounted) return;
    progress = SpProgress.show(
      context,
      title: '导入数据',
      text: '请稍后...',
      onTaskbar: true,
    );
    var data = UigfModelFull.fromJson(fileJson);
    await sqliteUser.importUigf(data);
    progress.end();
    await refreshData();
    if (context.mounted) {
      await SpInfobar.success(context, '导入成功');
    }
  }

  Future<void> exportUigf4Json(BuildContext context) async {
    var check = await SpDialog.confirm(context, '是否导出当前UID数据？', 'UID: $curUid');
    if (check == null || !check) return;
    var data = await sqliteUser.exportUigf(uids: [curUid!]);
    var downloadPath = await getDownloadsDirectory();
    if (!context.mounted || downloadPath == null) {
      if (context.mounted) await SpInfobar.error(context, '导出失败');
      return;
    }
    var dirPath = await fileTool.selectDir(context: context);
    if (dirPath == null) {
      if (context.mounted) await SpInfobar.warn(context, '未选择目录');
      return;
    }
    var fileName = 'uigf_${DateTime.now().millisecondsSinceEpoch}.json';
    var filePath = path.join(dirPath, fileName);
    await fileTool.writeFile(filePath, jsonEncode(data));
    if (context.mounted) {
      await SpInfobar.success(context, '导出成功');
    }
  }

  Future<void> refreshUserGacha(
    BuildContext context,
    UserBBSModel user,
    UserNapModel account,
  ) async {
    if (context.mounted) {
      progress = SpProgress.show(
        context,
        title: '获取调频数据',
        text: '请稍后...',
        onTaskbar: true,
      );
    }
    var apiGacha = SprNapApiGacha();
    var apiToken = SprNapApiAccount();
    progress.update(text: '正在获取AuthKey...');
    var authKeyResp = await apiToken.genAuthKey(user.cookie!, account);
    if (authKeyResp.retcode != 0) {
      progress.end();
      if (context.mounted) await SpInfobar.bbs(context, authKeyResp);
      return;
    }
    progress.update(text: '获取AuthKey成功，正在获取调频数据...');
    var authKeyData = authKeyResp.data as NapAuthkeyModelData;
    var authKey = authKeyData.authkey;
    var poolTypeList = [
      UigfNapPoolType.normal,
      UigfNapPoolType.bond,
      UigfNapPoolType.upC,
      UigfNapPoolType.upW,
    ];
    for (var poolType in poolTypeList) {
      progress.update(text: '开始获取${poolType.label}池数据...');
      var page = 1;
      String? endId;
      while (true) {
        var gachaResp = await apiGacha.getGachaLogs(
          account,
          user.cookie!,
          authKey,
          gachaType: poolType,
          page: page,
          endId: endId,
        );
        if (gachaResp.retcode != 0) {
          progress.end();
          if (context.mounted) await SpInfobar.bbs(context, gachaResp);
          return;
        }
        var gachaData = gachaResp.data as NapGachaModelData;
        progress.update(text: '正在导入${poolType.label}池数据，第$page页...');
        await sqliteUser.importNapGacha(account.gameUid, gachaData.list);
        if (gachaData.list.isEmpty || gachaData.list.length < 20) {
          progress.update(text: '获取${poolType.label}池数据完成');
          break;
        }
        endId = gachaData.list.last.id;
        page++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    progress.end();
    if (context.mounted) await SpInfobar.success(context, '刷新成功');
    await refreshData();
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Button(
          onPressed: () async {
            await importUigf4Json(context);
          },
          child: const Text('导入'),
        ),
        SizedBox(width: 10.w),
        Button(
          onPressed: () async {
            if (curUid == null) {
              await SpInfobar.warn(context, '未选择UID');
              return;
            }
            await exportUigf4Json(context);
          },
          child: const Text('导出'),
        ),
        SizedBox(width: 10.w),
        Button(
          child: const Text('刷新'),
          onPressed: () async {
            var curUser = ref.read(userBbsStoreProvider).user;
            if (curUser == null) {
              if (context.mounted) {
                await SpInfobar.warn(context, '未登录');
              }
              return;
            }
            var curAccount = ref.read(userBbsStoreProvider).account;
            if (curAccount == null) {
              if (context.mounted) {
                await SpInfobar.warn(context, '未登录');
              }
              return;
            }
            var check = await SpDialog.confirm(
              context,
              '是否刷新用户调频数据？',
              '${curAccount.nickname} '
                  'UID: ${curAccount.gameUid} [${curAccount.regionName}]',
            );
            if (check == null || !check) return;
            if (!context.mounted) return;
            await refreshUserGacha(context, curUser, curAccount);
          },
        ),
        SizedBox(width: 10.w),
        Button(
          child: const Text('删除'),
          onPressed: () async {
            if (curUid == null) {
              await SpInfobar.warn(context, '未选择UID');
              return;
            }
            var check =
                await SpDialog.confirm(context, '是否删除当前UID数据？', 'UID: $curUid');
            if (check == null || !check) return;
            await sqliteUser.deleteUser(curUid!);
            await refreshData();
            if (context.mounted) {
              await SpInfobar.success(context, '删除成功');
            }
          },
        ),
        SizedBox(width: 10.w),
        IconButton(
          icon: const Icon(FluentIcons.database_refresh),
          onPressed: () async {
            await sqliteMap.preCheck();
            await hakushiApi.freshCharacter();
            await hakushiApi.freshWeapon();
            await hakushiApi.freshBangboo();
            if (context.mounted) {
              await SpInfobar.success(context, '刷新成功');
            }
          },
        ),
      ],
    );
  }

  Widget buildUidSelector(BuildContext context) {
    if (uidList.isEmpty) return const SizedBox();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('UID:'),
        SizedBox(width: 10.w),
        DropDownButton(
          title: Text(curUid ?? '请选择'),
          items: [
            for (var uid in uidList)
              MenuFlyoutItem(
                text: Text(uid),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      curUid = uid;
                    });
                  }
                },
              ),
          ],
        ),
        SizedBox(width: 10.w),
        Text(
          '当前时区: ${DateTime.now().timeZoneName}'
          '(UTC${DateTime.now().timeZoneOffset.inHours})',
        ),
      ],
    );
  }

  /// 构建头部
  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10.w),
          const Icon(FluentIcons.auto_enhance_on),
          SizedBox(width: 10.w),
          Text('调频记录', style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 10.w),
          buildUidSelector(context),
          const Spacer(),
          buildTopBar(context),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: buildHeader(),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: curUid == null
            ? const Center(child: Text('暂无数据'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: UserGachaViewWidget(selectedUid: curUid!)),
                ],
              ),
      ),
    );
  }
}

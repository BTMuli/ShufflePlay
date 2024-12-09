// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_gacha_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/gacha/nap_gacha_model.dart';
import '../../models/nap/token/nap_authkey_model.dart';
import '../../plugins/Hakushi/hakushi_client.dart';
import '../../plugins/UIGF/models/uigf_enum.dart';
import '../../plugins/UIGF/models/uigf_model.dart';
import '../../plugins/UIGF/uigf_tool.dart';
import '../../request/nap/nap_api_account.dart';
import '../../request/nap/nap_api_gacha.dart';
import '../../shared/database/nap_item_map.dart';
import '../../shared/database/user_gacha.dart';
import '../../shared/store/user_bbs.dart';
import '../../shared/tools/file_tool.dart';
import '../ui/sp_dialog.dart';
import '../ui/sp_infobar.dart';
import '../ui/sp_progress.dart';
import '../widgets/app_top.dart';
import '../widgets/user_gacha_list.dart';

/// 调频记录
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
  late SpProgressController progress = SpProgressController();

  /// Tab控制器
  final tab = MacosTabController(initialIndex: 0, length: 4);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await refreshData();
      await refreshMetaData();
    });
  }

  /// 刷新用户数据
  Future<void> refreshData() async {
    uidList = await sqliteUser.getAllUid(check: true);
    if (uidList.isNotEmpty) {
      if (curUid == null || !uidList.contains(curUid)) {
        curUid = uidList.first;
      }
    } else {
      curUid = null;
    }
    if (mounted) setState(() {});
  }

  /// 刷新元数据
  Future<void> refreshMetaData() async {
    await sqliteMap.preCheck();
    await hakushiApi.freshCharacter();
    await hakushiApi.freshWeapon();
    await hakushiApi.freshBangboo();
    if (mounted) await SpInfobar.success(context, '刷新元数据成功');
  }

  /// 导入UIGF4Json
  Future<void> importUigf4Json() async {
    var filePath = await fileTool.selectFile(context: context);
    if (filePath == null) {
      if (mounted) await SpInfobar.warn(context, '未选择文件');
      return;
    }
    var file = await fileTool.readFile(filePath);
    if (file == null) {
      if (mounted) await SpInfobar.error(context, '文件读取失败');
      return;
    }
    try {
      jsonDecode(file);
    } catch (e) {
      if (mounted) await SpInfobar.error(context, '文件解析失败');
      return;
    }
    var fileJson = jsonDecode(file);
    var result = await uigfTool.validate(fileJson);
    if (!result.isValid) {
      var error = result.errors.first;
      if (mounted) {
        await SpInfobar.error(context, '文件解析失败: ${error.message}');
      }
      return;
    }
    if (!mounted) return;
    progress = SpProgress.show(context, title: '导入数据', text: '请稍后...');
    var data = UigfModelFull.fromJson(fileJson);
    await sqliteUser.importUigf(data);
    progress.end();
    await refreshData();
    if (mounted) {
      await SpInfobar.success(context, '导入成功');
    }
  }

  /// 导出UIGF4Json
  Future<void> exportUigf4Json() async {
    if (curUid == null) {
      if (mounted) await SpInfobar.warn(context, '未选择UID');
      return;
    }
    var check = await SpDialog.confirm(context, '是否导出当前UID数据？', 'UID: $curUid');
    if (check == null || !check) return;
    var data = await sqliteUser.exportUigf(uids: [curUid!]);
    var downloadPath = await getDownloadsDirectory();
    if (downloadPath == null) {
      if (mounted) await SpInfobar.error(context, '导出失败');
      return;
    }
    if (mounted) {
      var dirPath = await fileTool.selectDir(
        initialDirectory: downloadPath.path,
        confirmButtonText: '导出',
      );
      if (dirPath == null) {
        if (mounted) await SpInfobar.warn(context, '未选择目录');
        return;
      }
      var fileName = 'uigf_${DateTime.now().millisecondsSinceEpoch}.json';
      var filePath = path.join(dirPath, fileName);
      await fileTool.writeFile(filePath, jsonEncode(data));
      if (mounted) await SpInfobar.success(context, '导出成功');
    }
  }

  /// 删除用户
  Future<void> deleteUser() async {
    if (curUid == null) {
      if (mounted) await SpInfobar.warn(context, '未选择UID');
      return;
    }
    var check = await SpDialog.confirm(context, '是否删除当前UID数据？', 'UID: $curUid');
    if (check == null || !check) return;
    await sqliteUser.deleteUser(curUid!);
    await refreshData();
    if (mounted) await SpInfobar.success(context, '删除成功');
  }

  /// 尝试刷新用户调频数据
  Future<void> tryRefreshUserGacha({bool isForce = false}) async {
    var curUser = ref.read(userBbsStoreProvider).user;
    if (curUser == null) {
      if (mounted) await SpInfobar.warn(context, '未登录');
      return;
    }
    var curAccount = ref.read(userBbsStoreProvider).account;
    if (curAccount == null) {
      if (mounted) await SpInfobar.warn(context, '未登录');
      return;
    }
    var title = isForce ? '全量刷新用户调频数据？' : '增量刷新用户调频数据？';
    var text = '${curAccount.nickname} '
        'UID: ${curAccount.gameUid} '
        '[${curAccount.regionName}]';
    var check = await SpDialog.confirm(context, title, text);
    if (check == null || !check) return;
    if (mounted) {
      await refreshUserGacha(context, curUser, curAccount, isForce: isForce);
    }
  }

  /// 刷新用户调频数据
  Future<void> refreshUserGacha(
    BuildContext context,
    UserBBSModel user,
    UserNapModel account, {
    bool isForce = false,
  }) async {
    if (context.mounted) {
      progress = SpProgress.show(context, title: '获取调频数据', text: '请稍后...');
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
      UserGachaRefreshModel lastData = UserGachaRefreshModel(poolType);
      if (!isForce) {
        progress.update(text: '正在获取${poolType.label}池最新数据...');
        lastData = await sqliteUser.getLatestGacha(
          account.gameUid,
          poolType,
        );
      }
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
        if (!isForce && lastData.id != null) {
          if (gachaData.list.any((element) => element.id == lastData.id)) {
            progress.update(text: '获取${poolType.label}池数据完成');
            break;
          }
        }
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

  List<ToolBarIconButton> buildActions(BuildContext context) {
    return [
      ToolBarIconButton(
        label: '导入',
        icon: MacosIcon(Icons.file_download),
        showLabel: true,
        onPressed: importUigf4Json,
      ),
      ToolBarIconButton(
        label: '导出',
        icon: MacosIcon(Icons.file_upload),
        showLabel: true,
        onPressed: exportUigf4Json,
      ),
      ToolBarIconButton(
        label: '刷新',
        icon: MacosIcon(Icons.refresh),
        showLabel: true,
        onPressed: tryRefreshUserGacha,
      ),
      ToolBarIconButton(
        label: '全量刷新',
        icon: MacosIcon(Icons.cloud_download),
        showLabel: true,
        onPressed: () async => await tryRefreshUserGacha(isForce: true),
      ),
      ToolBarIconButton(
        label: '刷新元数据',
        icon: MacosIcon(Icons.dataset_outlined),
        showLabel: true,
        onPressed: refreshMetaData,
      ),
      ToolBarIconButton(
        label: '删除',
        icon: MacosIcon(Icons.delete_forever),
        showLabel: true,
        onPressed: deleteUser,
      ),
      buildTopTrailing(context),
    ];
  }

  MacosPopupMenuItem<String> buildUidSelectorItem(String uid) {
    return MacosPopupMenuItem<String>(value: uid, child: Text(uid));
  }

  Widget buildUidSelector(BuildContext context) {
    if (uidList.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('UID:'),
        SizedBox(width: 10),
        MacosPopupButton<String>(
          items: uidList.map(buildUidSelectorItem).toList(),
          onChanged: (String? value) {
            curUid = value;
            if (mounted) setState(() {});
          },
          hint: Text(curUid ?? '选择UID'),
        ),
        SizedBox(width: 10),
        Text(
          '当前时区: ${DateTime.now().timeZoneName}'
          '(UTC${DateTime.now().timeZoneOffset.inHours})',
        )
      ],
    );
  }

  Widget buildTitle(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 60,
        child: Text('调频记录', style: MacosTheme.of(context).typography.headline),
      ),
      buildUidSelector(context),
    ]);
  }

  Widget buildContent() {
    return MacosTabView(
      controller: tab,
      tabs: [
        MacosTab(label: '常驻'),
        MacosTab(label: '角色UP'),
        MacosTab(label: '音擎UP'),
        MacosTab(label: '邦布'),
      ],
      children: [
        UserGachaList(curUid!, UigfNapPoolType.normal),
        UserGachaList(curUid!, UigfNapPoolType.upC),
        UserGachaList(curUid!, UigfNapPoolType.upW),
        UserGachaList(curUid!, UigfNapPoolType.bond),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: buildTitle(context),
        titleWidth: 500,
        leading: buildTopLeading(context),
        actions: buildActions(context),
      ),
      children: [
        ContentArea(
          builder: (_, __) => Padding(
            padding: EdgeInsets.all(8),
            child: curUid == null
                ? Text('暂无数据', style: TextStyle(color: Colors.white))
                : buildContent(),
          ),
        )
      ],
    );
  }
}

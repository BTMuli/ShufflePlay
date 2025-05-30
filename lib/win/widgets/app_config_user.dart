// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Icons;

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../../../../models/bbs/info/bbs_info_user_model.dart';
import '../../../../models/bbs/token/bbs_token_model.dart';
import '../../../../models/database/user/user_bbs_model.dart';
import '../../../../models/database/user/user_nap_model.dart';
import '../../../../models/nap/account/nap_account_model.dart';
import '../../../../request/bbs/bbs_api_info.dart';
import '../../../../request/bbs/bbs_api_token.dart';
import '../../../../request/nap/nap_api_account.dart';
import '../../../../shared/database/user_nap.dart';
import '../../../../shared/store/user_bbs.dart';
import '../ui/sp_dialog.dart';
import '../ui/sp_icon.dart';
import '../ui/sp_infobar.dart';

class AppConfigUserWidget extends ConsumerStatefulWidget {
  const AppConfigUserWidget({super.key});

  @override
  ConsumerState<AppConfigUserWidget> createState() =>
      _AppConfigUserWidgetState();
}

class _AppConfigUserWidgetState extends ConsumerState<AppConfigUserWidget> {
  /// uid
  List<String> get uids => ref.watch(userBbsStoreProvider).uids;

  /// 当前用户uid
  String? get uid => ref.watch(userBbsStoreProvider).uid;

  /// 当前用户
  UserBBSModel? get user => ref.watch(userBbsStoreProvider).user;

  /// 所有用户
  List<UserBBSModel> get users => ref.watch(userBbsStoreProvider).users;

  /// nap数据库
  final sqliteNap = SpsUserNap();

  @override
  void initState() {
    super.initState();
  }

  /// 获取用户信息
  Future<UserBBSModelBrief?> getUserBrief(UserBBSModelCookie cookie) async {
    var bbsInfoApi = SprBbsApiInfo();
    var resp = await bbsInfoApi.getUserInfo(cookie);
    if (resp.retcode != 0 || resp is! BbsInfoUserModelResp) {
      if (mounted) {
        await SpInfobar.warn(context, '获取用户信息失败：${resp.message}');
      }
      return null;
    }
    var data = resp.data as BbsInfoUserModelDataFull;
    if (mounted) await SpInfobar.success(context, '获取用户信息成功');
    return UserBBSModelBrief(
      uid: data.userInfo.uid,
      username: data.userInfo.nickname,
      avatar: data.userInfo.avatarUrl,
      sign: data.userInfo.introduce,
    );
  }

  /// 添加用户-通过cookie
  Future<void> addUserByCookie() async {
    var cookieInput = await SpDialog.input(
      context,
      '添加用户',
      'Cookie',
      copy: true,
      label: 'stoken=xxx;stuid=xxx;mid=xxx;',
    );
    if (cookieInput == null || cookieInput.isEmpty) {
      if (mounted) await SpInfobar.warn(context, '未输入cookie');
      return;
    }
    UserBBSModelCookie? cookie;
    try {
      cookie = UserBBSModelCookie.fromString(cookieInput);
    } catch (e) {
      if (mounted) await SpInfobar.warn(context, 'cookie格式错误，或缺失必要字段');
      return;
    }
    if (cookie.stoken.isEmpty || cookie.stuid.isEmpty || cookie.mid.isEmpty) {
      if (mounted) await SpInfobar.warn(context, 'cookie格式错误，或缺失必要字段');
      return;
    }
    cookie = await refreshCookie(cookie);
    UserBBSModelBrief? brief = await getUserBrief(cookie);
    var user = UserBBSModel(uid: cookie.stuid, cookie: cookie, brief: brief);
    await ref.read(userBbsStoreProvider).addUser(user);
    await refreshGameAccounts(user);
  }

  /// 添加用户-通过二维码
  Future<void> addUserByQrCode() async {
    var cookie = await SpDialog.loginByQr(context);
    if (cookie == null) {
      if (mounted) await SpInfobar.warn(context, '未获取到cookie');
      return;
    }
    cookie = await refreshCookie(cookie);
    debugPrint(cookie.toString());
    UserBBSModelBrief? brief = await getUserBrief(cookie);
    var user = UserBBSModel(uid: cookie.stuid, cookie: cookie, brief: brief);
    await ref.read(userBbsStoreProvider).addUser(user);
    await refreshGameAccounts(user);
  }

  /// 刷新用户cookie
  Future<UserBBSModelCookie> refreshCookie(UserBBSModelCookie cookie) async {
    if (cookie.stoken.isEmpty || cookie.stuid.isEmpty || cookie.mid.isEmpty) {
      if (mounted) await SpInfobar.warn(context, 'cookie格式错误，或缺失必要字段');
      return cookie;
    }
    var bbsTokenApi = SprBbsApiToken();
    var ltokenResp = await bbsTokenApi.getLToken(cookie);
    if (ltokenResp.retcode != 0 || ltokenResp is! BbsTokenModelLbSResp) {
      if (mounted) {
        await SpInfobar.warn(context, '获取ltoken失败：${ltokenResp.message}');
      }
      return cookie;
    } else {
      var ltokenData = ltokenResp.data as BbsTokenModelLbSData;
      cookie.ltoken = ltokenData.ltoken;
    }
    var cookieTokenResp = await bbsTokenApi.getCookieToken(cookie);
    if (cookieTokenResp.retcode != 0 ||
        cookieTokenResp is! BbsTokenModelCbSResp) {
      if (mounted) {
        await SpInfobar.warn(
          context,
          '获取cookieToken失败：${cookieTokenResp.message}',
        );
      }
      return cookie;
    } else {
      var cookieTokenData = cookieTokenResp.data as BbsTokenModelCbSData;
      cookie.cookieToken = cookieTokenData.cookieToken;
    }
    if (mounted) await SpInfobar.success(context, '获取Cookie成功');
    return cookie;
  }

  /// 刷新用户账户信息
  Future<void> refreshGameAccounts(UserBBSModel user) async {
    var api = SprNapApiAccount();
    var resp = await api.getGameAccounts(user.cookie!);
    if (resp.retcode != 0 || resp is! NapAccountModelResp) {
      if (mounted) {
        await SpInfobar.warn(context, '获取用户账户信息失败：${resp.message}');
      }
      return;
    }
    var data = resp.data as NapAccountModelData;
    var accounts = data.list;
    for (var account in accounts) {
      var userNap = UserNapModel(
        uid: user.uid,
        gameBiz: account.gameBiz,
        gameUid: account.gameUid,
        isChosen: account.isChosen,
        isOfficial: account.isOfficial,
        level: account.level,
        nickname: account.nickname,
        region: account.region,
        regionName: account.regionName,
      );
      await sqliteNap.insertUser(userNap);
    }
    if (mounted) await SpInfobar.success(context, '获取用户账户信息成功');
  }

  /// 刷新用户信息
  Future<void> refreshUser(UserBBSModel user) async {
    var cookie = user.cookie;
    if (cookie == null) {
      if (mounted) await SpInfobar.warn(context, '用户cookie为空');
      return;
    }
    cookie = await refreshCookie(cookie);
    UserBBSModelBrief? brief = await getUserBrief(cookie);
    var newUser = UserBBSModel(uid: user.uid, cookie: cookie, brief: brief);
    await ref.read(userBbsStoreProvider).updateUser(newUser);
    await refreshGameAccounts(newUser);
  }

  /// 构建用户尾部
  Widget buildUserTrailing(UserBBSModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const SPIcon(FluentIcons.refresh),
          onPressed: () async {
            var check = await SpDialog.confirm(
              context,
              '刷新用户信息',
              '确认刷新用户信息？',
            );
            if (check == null || !check) return;
            await refreshUser(user);
          },
        ),
        SizedBox(width: 8.w),
        IconButton(
          icon: const SPIcon(FluentIcons.delete),
          onPressed: () async {
            var check = await SpDialog.confirm(
              context,
              '删除用户',
              '确认删除用户？',
            );
            if (check == null || !check) return;
            await ref.read(userBbsStoreProvider).deleteUser(user.uid);
          },
        ),
      ],
    );
  }

  /// 构建登录尾部
  Widget buildLoginTrailing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Tooltip(
          message: 'Cookie登录',
          child: IconButton(
            icon: const SPIcon(Icons.cookie),
            onPressed: () async => await addUserByCookie(),
          ),
        ),
        if (kDebugMode) ...[
          SizedBox(width: 8.w),
          Tooltip(
            message: '短信验证码登录',
            child: IconButton(
              icon: const SPIcon(FluentIcons.comment_active),
              onPressed: () async {
                if (context.mounted) {
                  await SpInfobar.warn(context, '暂未实现');
                }
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expander(
      initiallyExpanded: uids.isEmpty,
      leading: uids.isEmpty
          ? const Icon(FluentIcons.user_warning)
          : const Icon(FluentIcons.group),
      header: user?.brief?.username.isNotEmpty ?? false
          ? Text('${user?.brief?.username}（${user?.uid}）')
          : Text(user?.uid ?? '未登录'),
      content: Column(
        children: <Widget>[
          for (final UserBBSModel user in users)
            ListTile.selectable(
              leading: user.brief?.avatar != null
                  ? SizedBox(
                      width: 32.sp,
                      height: 32.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.sp),
                        child: CachedNetworkImage(
                          imageUrl: user.brief!.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const Icon(FluentIcons.user_sync),
              title: Text(user.brief?.username.isNotEmpty ?? false
                  ? '${user.brief?.username}（${user.uid}）'
                  : user.uid),
              subtitle: Text(user.brief?.sign ?? '暂无签名'),
              trailing: buildUserTrailing(user),
              selected: user.uid == uid,
              onPressed: () {
                if (uid == null || uid == user.uid) {
                  return;
                }
                ref.read(userBbsStoreProvider).switchUser(user.uid);
                setState(() {});
              },
            ),
          ListTile(
            leading: const SPIcon(FluentIcons.add),
            title: const Text('添加用户'),
            onPressed: () async => await addUserByQrCode(),
            trailing: buildLoginTrailing(),
          )
        ],
      ),
    );
  }
}

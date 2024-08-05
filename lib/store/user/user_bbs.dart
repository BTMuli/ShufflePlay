// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../database/user/user_bbs.dart';
import '../../database/user/user_nap.dart';
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';

/// 用户信息状态提供者
final uerBbsStoreProvider = ChangeNotifierProvider<SpUserBbsStore>((ref) {
  return SpUserBbsStore();
});

/// 用户信息状态
class SpUserBbsStore extends ChangeNotifier {
  /// 用户信息数据库
  final SpsUserBbs sqlite = SpsUserBbs();

  /// 用户游戏账号数据库
  final SpsUserNap sqliteNap = SpsUserNap();

  /// uid列表
  List<String> _uids = [];

  /// 当前用户uid
  String? _uid;

  /// 当前用户
  UserBBSModel? _user;

  /// 所有用户
  List<UserBBSModel> _users = [];

  /// 当前用户的账户
  UserNapModel? _account;

  /// 当前用户的账户列表
  List<UserNapModel> _accounts = [];

  /// 获取uid列表
  List<String> get uids => _uids;

  /// 获取当前用户uid
  String? get uid => _uid;

  /// 获取当前用户
  UserBBSModel? get user => _user;

  /// 获取所有用户
  List<UserBBSModel> get users => _users;

  /// 当前用户对应的账户
  UserNapModel? get account => _account;

  /// 当前用户对应的账户列表
  List<UserNapModel> get accounts => _accounts;

  /// 构造函数
  SpUserBbsStore() {
    initUser();
    initAccount();
  }

  /// 初始化用户信息
  Future<void> initUser() async {
    _uids = await sqlite.readAllUids();
    if (_uids.isNotEmpty) {
      _users = await sqlite.readAllUsers();
      _uid = _uids.first;
      _user = _users.first;
    }
    notifyListeners();
  }

  /// 初始化用户账户
  Future<void> initAccount() async {
    if (_uid != null) {
      _accounts = await sqliteNap.readUser(_uid!);
      if (_accounts.isNotEmpty) {
        _account = _accounts.first;
      }
    }
    notifyListeners();
  }

  /// 切换用户
  Future<void> switchUser(String uid) async {
    _uid = uid;
    _user = await sqlite.readUser(_uid!);
    _accounts = await sqliteNap.readUser(_uid!);
    if (_accounts.isNotEmpty) {
      _account = _accounts.first;
    }
    notifyListeners();
  }

  /// 删除用户
  Future<void> deleteUser(String uid) async {
    await sqlite.deleteUser(uid);
    _uids.remove(uid);
    _users.removeWhere((element) => element.uid == uid);
    if (_uids.isNotEmpty) {
      _uid = _uids.first;
      _user = _users.first;
      _accounts = await sqliteNap.readUser(_uid!);
      if (_accounts.isNotEmpty) {
        _account = _accounts.first;
      }
    } else {
      _uid = null;
      _user = null;
      _account = null;
      _accounts = [];
    }
    notifyListeners();
  }

  /// 添加用户
  Future<void> addUser(UserBBSModel user) async {
    await sqlite.writeUser(user);
    _uids.add(user.uid);
    _users.add(user);
    _uid = user.uid;
    _user = user;
    _accounts = await sqliteNap.readUser(_uid!);
    if (_accounts.isNotEmpty) {
      _account = _accounts.first;
    }
    notifyListeners();
  }

  /// 更新用户
  Future<void> updateUser(UserBBSModel user) async {
    await sqlite.writeUser(user);
    var userFind = _users.firstWhere((element) => element.uid == user.uid);
    var index = _users.indexOf(userFind);
    _users[index] = user;
    _user = user;
    _accounts = await sqliteNap.readUser(_uid!);
    if (_accounts.isNotEmpty) {
      _account = _accounts.first;
    }
    notifyListeners();
  }
}

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../database/user/user_bbs.dart';
import '../../models/database/user/user_bbs_model.dart';

/// 用户信息状态提供者
final uerBbsStoreProvider = ChangeNotifierProvider<SpUserBbsStore>((ref) {
  return SpUserBbsStore();
});

/// 用户信息状态
class SpUserBbsStore extends ChangeNotifier {
  /// 用户信息数据库
  final SpsUserBbs sqlite = SpsUserBbs();

  /// uid列表
  List<String> _uids = [];

  /// 当前用户uid
  String? _uid;

  /// 当前用户
  UserBBSModel? _user;

  /// 所有用户
  List<UserBBSModel> _users = [];

  /// 获取uid列表
  List<String> get uids => _uids;

  /// 获取当前用户uid
  String? get uid => _uid;

  /// 获取当前用户
  UserBBSModel? get user => _user;

  /// 获取所有用户
  List<UserBBSModel> get users => _users;

  /// 构造函数
  SpUserBbsStore() {
    initUser();
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

  /// 切换用户
  Future<void> switchUser(String uid) async {
    _uid = uid;
    _user = await sqlite.readUser(_uid!);
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
    } else {
      _uid = null;
      _user = null;
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
    notifyListeners();
  }

  /// 更新用户
  Future<void> updateUser(UserBBSModel user) async {
    await sqlite.writeUser(user);
    var userFind = _users.firstWhere((element) => element.uid == user.uid);
    var index = _users.indexOf(userFind);
    _users[index] = user;
    _user = user;
    notifyListeners();
  }
}

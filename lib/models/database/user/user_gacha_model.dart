// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../plugins/UIGF/uigf_enum.dart';
import '../../plugins/UIGF/uigf_model.dart';

/// UserGacha 表的数据模型
/// 该表在 lib/database/user/user_gacha.dart 中定义
part 'user_gacha_model.g.dart';

/// UserGacha 表的数据模型
@JsonSerializable(explicitToJson: true)
class UserGachaModel extends UigfModelNapItem {
  /// 用户ID
  @JsonKey(name: 'uid')
  final String uid;

  /// 构造函数
  UserGachaModel({
    required this.uid,
    required super.gachaType,
    required super.itemId,
    required super.time,
    required super.id,
    super.gachaId,
    super.count,
    super.itemType,
    super.name,
    super.rankType,
  });

  /// 从 JSON 中构造
  factory UserGachaModel.fromJson(Map<String, dynamic> json) =>
      _$UserGachaModelFromJson(json);

  /// from sql json
  factory UserGachaModel.fromSqlJson(Map<String, dynamic> json) {
    return UserGachaModel(
      uid: json['uid'] as String,
      gachaId: json['gacha_type'] as String?,
      gachaType: UigfNapPoolType.values.firstWhere(
        (element) => element.value == json['gacha_type'],
        orElse: () => json['gacha_type'] as UigfNapPoolType,
      ),
      itemId: json['item_id'] as String,
      count: json['count'] as String?,
      time: json['time'] as String,
      name: json['name'] as String?,
      itemType: json['item_type'] as String?,
      rankType: json['rank_type'] as String?,
      id: json['id'] as String,
    );
  }

  /// 转换为 JSON
  @override
  Map<String, dynamic> toJson() => _$UserGachaModelToJson(this);

  /// to sql json
  Map<String, dynamic> toSqlJson() {
    return {
      'uid': uid,
      'gacha_type': gachaType.value,
      'item_id': itemId,
      'time': time,
      'id': id,
      'gacha_id': gachaId,
      'count': count,
      'name': name,
      'item_type': itemType,
      'rank_type': rankType,
    };
  }
}

// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'nap_base_model.g.dart';

@JsonSerializable()
class NapBaseModelPropertyFull {
  /// property_name
  @JsonKey(name: 'property_name')
  final String propertyName;

  /// property_id
  @JsonKey(name: 'property_id')
  final int propertyId;

  /// base
  @JsonKey(name: 'base')
  final String base;

  /// level
  @JsonKey(name: 'level')
  final int level;

  /// valid
  @JsonKey(name: 'valid')
  final bool valid;

  /// system_id
  @JsonKey(name: 'system_id')
  final int systemId;

  /// add
  @JsonKey(name: 'add')
  final int add;

  /// constructor
  NapBaseModelPropertyFull({
    required this.propertyName,
    required this.propertyId,
    required this.base,
    required this.level,
    required this.valid,
    required this.systemId,
    required this.add,
  });

  /// from json
  factory NapBaseModelPropertyFull.fromJson(Map<String, dynamic> json) =>
      _$NapBaseModelPropertyFullFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapBaseModelPropertyFullToJson(this);
}

@JsonSerializable()
class NapBaseModelProperty {
  /// property_name
  @JsonKey(name: 'property_name')
  final String propertyName;

  /// property_id
  @JsonKey(name: 'property_id')
  final int propertyId;

  /// base
  @JsonKey(name: 'base')
  final String base;

  /// add
  @JsonKey(name: 'add')
  final String add;

  /// final
  @JsonKey(name: 'final')
  final String finalProp;

  /// constructor
  NapBaseModelProperty({
    required this.propertyName,
    required this.propertyId,
    required this.base,
    required this.add,
    required this.finalProp,
  });

  /// from json
  factory NapBaseModelProperty.fromJson(Map<String, dynamic> json) =>
      _$NapBaseModelPropertyFromJson(json);

  /// to json
  Map<String, dynamic> toJson() => _$NapBaseModelPropertyToJson(this);
}

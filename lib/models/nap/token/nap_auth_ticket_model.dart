// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../../bbs/bbs_base_model.dart';

part 'nap_auth_ticket_model.g.dart';

/// 获取authTicket返回
@JsonSerializable(explicitToJson: true, createToJson: false)
class NapAuthTicketModelResp extends BBSResp<NapAuthTicketModelData> {
  NapAuthTicketModelResp({
    required super.retcode,
    required super.message,
    required NapAuthTicketModelData super.data,
  });

  factory NapAuthTicketModelResp.fromJson(Map<String, dynamic> json) =>
      _$NapAuthTicketModelRespFromJson(json);
}

/// 获取authTicket返回data
@JsonSerializable()
class NapAuthTicketModelData {
  /// ticket
  @JsonKey(name: 'ticket')
  final String ticket;

  /// constructor
  NapAuthTicketModelData({
    required this.ticket,
  });

  /// fromJson
  factory NapAuthTicketModelData.fromJson(Map<String, dynamic> json) =>
      _$NapAuthTicketModelDataFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$NapAuthTicketModelDataToJson(this);
}

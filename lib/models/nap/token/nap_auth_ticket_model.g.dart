// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nap_auth_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NapAuthTicketModelResp _$NapAuthTicketModelRespFromJson(
        Map<String, dynamic> json) =>
    NapAuthTicketModelResp(
      retcode: (json['retcode'] as num).toInt(),
      message: json['message'] as String,
      data:
          NapAuthTicketModelData.fromJson(json['data'] as Map<String, dynamic>),
    );

NapAuthTicketModelData _$NapAuthTicketModelDataFromJson(
        Map<String, dynamic> json) =>
    NapAuthTicketModelData(
      ticket: json['ticket'] as String,
    );

Map<String, dynamic> _$NapAuthTicketModelDataToJson(
        NapAuthTicketModelData instance) =>
    <String, dynamic>{
      'ticket': instance.ticket,
    };

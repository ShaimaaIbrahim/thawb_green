// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_order_item_response_online.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralOrderItemResponse1 _$GeneralOrderItemResponse1FromJson(
    Map<String, dynamic> json) {
  return GeneralOrderItemResponse1(
    json['status'] as bool,
    json['msg'] as String,
    (json['result'] as List)
        .map((e) =>
            e = GeneralOrderItemModel1.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GeneralOrderItemResponse1ToJson(
        GeneralOrderItemResponse1 instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.msg,
      'result': instance.result,
    };

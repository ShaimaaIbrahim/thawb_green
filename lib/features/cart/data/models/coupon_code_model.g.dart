// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponCodeModel _$CouponCodeModelFromJson(Map<String, dynamic> json) {
  return CouponCodeModel(
      total: json['total'],
      couponCode: json['couponcode'],
      couponId: json['coupon_id'],
      discount: json['discount'],
      discountamount: json['discountamount'],
      type: json['type'],
      couponcode_type: json['couponcode_type']);
}

Map<String, dynamic> _$CouponCodeModelToJson(CouponCodeModel instance) =>
    <String, dynamic>{
      'coupon_id': instance.couponId,
      'discountamount': instance.discountamount,
      'discount': instance.discount,
      'couponcode': instance.couponCode,
      'total': instance.total,
      'type': instance.type,
      'couponcode_type': instance.couponcode_type
    };

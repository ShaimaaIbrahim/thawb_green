import 'package:ojos_app/core/models/base_model.dart';
import 'package:ojos_app/features/cart/domin/entities/coupon_code_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domin/entities/coupon_code_entity.dart';
part 'coupon_code_model.g.dart';

@JsonSerializable()
class CouponCodeModel extends BaseModel<CouponCodeEntity> {
  @JsonKey(name: 'coupon_id')
  final int? couponId;
  @JsonKey(name: 'discountamount')
  var discountamount;
  @JsonKey(name: 'discount')
  var discount;
  @JsonKey(name: 'couponcode')
  final String? couponCode;

  @JsonKey(name: 'couponcode_type')
  final String? couponcode_type;

  @JsonKey(name: 'total')
  var total;

  @JsonKey(name: 'type')
  final int? type;

  CouponCodeModel(
      {@required this.total,
      @required this.couponCode,
      @required this.couponId,
      @required this.discount,
      @required this.discountamount,
      @required this.type,
      required this.couponcode_type});

  factory CouponCodeModel.fromJson(Map<String, dynamic> json) =>
      _$CouponCodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponCodeModelToJson(this);

  @override
  CouponCodeEntity toEntity() => CouponCodeEntity(
      couponCode: this.couponCode!,
      couponId: this.couponId!,
      discount: this.discount!,
      discountamount: this.discountamount!,
      couponcode_type: this.couponcode_type,
      total: this.total!,
      type: this.type!);
}

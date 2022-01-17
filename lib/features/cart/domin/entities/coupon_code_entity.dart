import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/entities/base_entity.dart';

class CouponCodeEntity extends BaseEntity {
  final int? couponId;
  final String? discountamount;
  final String? discount;
  final String? couponCode;
  final String? total;
  final int? type;
  final String? couponcode_type;

  CouponCodeEntity(
      {required this.total,
      required this.couponCode,
      required this.couponId,
      required this.discount,
      required this.discountamount,
      required this.type,
      required this.couponcode_type});

  @override
  List<Object> get props => [
        total ?? '',
        couponCode ?? 0,
        couponId ?? '',
        discount ?? '',
        discountamount ?? '',
        type ?? 0,
        couponcode_type ?? ''
      ];
}

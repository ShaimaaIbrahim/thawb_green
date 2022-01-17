import 'package:flutter/cupertino.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';

class CheckAndPayArgs {
  final String date;
  final String totalPrice;
  final int shipping_id;
  final int city_id;
  final int orginal_price;
  final int price_discount;
  final int tax;
  final String? name;
  final String? phone;
  final String address;
  final int shipping_fee;
  final int total;
  final String note;
  final String point_map;
  final int? coupon_id;
  final int paymentMethods;
  final String couponcode;
  final List<CartEntity> listOfOrder;
  final int neighborhood_id;
  final int load_id;
  final String delivery_to;
  final String dest_name;
  final String guard_number;
  final int? dest_type;
  final String region;
  final String flat;
  final String street;
  final int discount;
  final int delivery_fee;

  const CheckAndPayArgs(
      {
        required this.delivery_fee,
        required this.discount,
      required this.region,
      required this.flat,
      required this.street,
      required this.date,
      required this.listOfOrder,
      required this.totalPrice,
      required this.couponcode,
      required this.city_id,
      required this.name,
      required this.phone,
      required this.address,
      required this.shipping_id,
      required this.paymentMethods,
      required this.point_map,
      required this.note,
      required this.coupon_id,
      required this.orginal_price,
      required this.shipping_fee,
      required this.price_discount,
      required this.total,
      required this.tax,
      required this.neighborhood_id,
      required this.load_id,
      required this.delivery_to,
      required this.dest_name,
      required this.guard_number,
      required this.dest_type});
}

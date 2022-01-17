import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_request.g.dart';

@JsonSerializable()
class OrderRequest {
  final int? method_id;
  final int? subtotal;
  final int? discount;

  final int? tax;
  final int? total;
  final int? delivery_fee;
  final String? note;
  final int? coupon_id;
  final String? name;
  final String? phone;
  final String? address;
  final String flat;
  final String region;
  final String street;
  final String order_date;

  final List<ProductOrderRequest>? cartItems;

  OrderRequest(
      {required this.order_date,
      required this.flat,
      required this.street,
      required this.region,
      required this.tax,
      required this.total,
      required this.delivery_fee,
      required this.discount,
      required this.coupon_id,
      required this.subtotal,
      required this.note,
      required this.cartItems,
      required this.method_id,
      required this.name,
      required this.phone,
      required this.address});

  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}

@JsonSerializable()
class ProductOrderRequest {
  final int? product_id;
  final int? type_product;
  final int? Is_Glasses;
  final String? colour_id;
  final String? size_id;
  final String? fabric_id;
  final String? length_id;
  final int? brand_id;
  final int? quantity;
  final double? price;

  ProductOrderRequest({
    required this.colour_id,
    required this.size_id,
    required this.fabric_id,
    required this.length_id,
    @required this.price,
    @required this.type_product,
    @required this.product_id,
    //  @required this.lens_size,
    @required this.quantity,
    // @required this.sizeMode,
    @required this.brand_id,
    //   @required this.color_id,
    @required this.Is_Glasses,
    // @required this.lens_left_size,
    //  @required this.lens_right_size,
  });

  factory ProductOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOrderRequestToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return this.toJson().toString();
  }
}

@JsonSerializable()
class DeliveryOrderRequest {
  final String? delivery_name;
  final String? delivery_mobile_1;
  final String? delivery_mobile_2;
  final String? delivery_email;
  final String? delivery_address;
  final String? delivery_city;
  final String? delivery_state;
  final String? delivery_zipcode;
  final String? delivery_phone;

  DeliveryOrderRequest({
    @required this.delivery_address,
    @required this.delivery_city,
    @required this.delivery_phone,
    @required this.delivery_state,
    @required this.delivery_zipcode,
    @required this.delivery_email,
    @required this.delivery_mobile_1,
    @required this.delivery_mobile_2,
    @required this.delivery_name,
  });

  factory DeliveryOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOrderRequestToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return this.toJson().toString();
  }
}

@JsonSerializable()
class CardOrderRequest {
  final String? number;
  final String? exp_month;
  final String? exp_year;
  final String? cvc;

  CardOrderRequest({
    @required this.number,
    @required this.cvc,
    @required this.exp_month,
    @required this.exp_year,
  });

  @override
  String toString() {
    // TODO: implement toString
    return this.toJson().toString();
  }

  factory CardOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CardOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CardOrderRequestToJson(this);
}

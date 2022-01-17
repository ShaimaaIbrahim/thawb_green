import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/models/base_model.dart';
import 'package:ojos_app/features/order/domain/entities/order_item_entity.dart';
import 'package:ojos_app/features/product/data/models/product_model.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemModel extends BaseModel<OrderItemEntity> {
  final int? order_id;
  final int? product_id;
  final int? quantity;
  final int? price;
  final String name;
  final image;
  final description;
  final int discount_price;
  final String discount_type;

  //final ProductModel? product;

  OrderItemModel(
      {
      //required this.product,
      required this.quantity,
      required this.price,
      required this.order_id,
      required this.product_id,
      required this.name,
      required this.discount_type,
      required this.discount_price,
      required this.description,
      required this.image});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  @override
  OrderItemEntity toEntity() => OrderItemEntity(/*id: this.id!*/);
}

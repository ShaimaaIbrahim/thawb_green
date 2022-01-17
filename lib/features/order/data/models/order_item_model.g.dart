// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return OrderItemModel(
    quantity: json['quantity'] as int,
    discount_price: json['discount_price'],
    description: json['description'],
    discount_type: json['discount_type'],
    image: json['image'],
    price: json['price'] as int,
    order_id: json['order_id'] as int,
    product_id: json['product_id'] as int,
    name: json['name'],
  );
}

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'order_id': instance.order_id,
      'product_id': instance.product_id,
      'quantity': instance.quantity,
      'price': instance.price,
      'image': instance.image,
      'description': instance.description,
      'discount_price': instance.discount_price,
      'discount_type': instance.discount_type,
      'name': instance.name,
    };

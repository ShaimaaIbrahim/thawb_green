// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralOrderItemModel _$GeneralOrderItemModelFromJson(
    Map<String, dynamic> json) {
  return GeneralOrderItemModel(
      id: json['id'] as int,
      address: json['address'] ?? '',
      user_id: json['user_id'] as int,
      total: json['subtotal'] as int,
      delivery_fee: json['delivery_fee'],
      discount: json['discount'] as int,
      uuid: json['uuid'],
      // status: json['status'] as String,
      orderimage: json['orderimage'] as String,
      // statusint: json['status'] as String,
      // billing_name: json['billing_name'] as String,
      // coupon_id: json['coupon_id'] as int,
      // delivery_address: json['neighborhood'] as String,
      // delivery_city: json['delivery_city'] as String,
      // delivery_phone: json['delivery_phone'] as String,
      // delivery_state: json['delivery_state'] as String,
      // paymentmehtod: json['mehtod_name'] as String,
      // delivery_zipcode: json['delivery_zipcode'] as String,
      note: json['note'] as String,
      order_items: (json['order_items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      //order_number: json['uuid'] as String,
      orginal_price: (json['subtotal'] as num).toDouble(),
      //  payment_id: json['payment_id'] as int,
      // point_map: json['point_map'] as String,
      // price_discount: json['discount'] as int,
      // shipping_fee: json['shipping_fee'] as int,
      // shipping_id: json['shipping_id'] as int,
      tax: json['tax'] as int,
      uid: json['uuid'] as String,
      payment_mehtod: json['payment_mehtod'],
      subtotal: json['subtotal'],
      status: json['status'],
      name: json['name'],
      phone: json['phone'],
      order_date: json['order_date']);
}

Map<String, dynamic> _$GeneralOrderItemModelToJson(
        GeneralOrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uid,
      'address': instance.address,
      // 'uuid': instance.order_number,
      'user_id': instance.user_id,
      //'coupon_id': instance.coupon_id,
      // 'shipping_id': instance.shipping_id,
      // 'shipping_fee': instance.shipping_fee,
      'note': instance.note,
      //'discount': instance.price_discount,
      'subtotal': instance.subtotal,
      'tax': instance.tax,
      'discount': instance.discount,
      'subtotal': instance.total,
      'mehtod_name': instance.payment_mehtod,
      'delivery_fee': instance.delivery_fee,
      'uuid': instance.uuid,
      'status': instance.status,
      'order_date': instance.order_date,
      //'delivery_fee': instance.delivery_fee,
      // 'neighborhood': instance.delivery_address,
      // 'delivery_city': instance.delivery_city,
      // 'delivery_state': instance.delivery_state,
      // 'delivery_zipcode': instance.delivery_zipcode,
      // 'delivery_phone': instance.delivery_phone,
      // 'billing_name': instance.billing_name,
      // 'point_map': instance.point_map,
      // 'status': instance.status,
      // 'status': instance.statusint,
      'orderimage': instance.orderimage,
      'order_items': instance.order_items,
      'name': instance.name,
      'phone': instance.phone
    };

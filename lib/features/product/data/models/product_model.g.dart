// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
      category_id: json['category_id'],
      name: json['name'],
      id: json['id'],
      isFavorite: json['isFavorite'],
      isReview: json['isReview'],
      is_new: json['is_new'],
      image: json['image'],
      price: json['price'],
      product_as_same: json['product_as_same'] != null
          ? json['product_as_same']
              .map((e) => e = ProductModel.fromJson(e as Map<String, String>))
              .toList()
          : [],
      discount_price: json['discount_price'],
      description: json['description'],
      discount_type: json['discount_type'],
      review_count: json['review_count'],
      rate: json['rate'],
      quantity: json['quantity']);
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'discount_type': instance.discount_type,
      'isFavorite': instance.isFavorite,
      'isReview': instance.isReview,
      'review_count': instance.review_count,
      'discount_price': instance.discount_price,
      'product_as_same': instance.product_as_same,
      'category_id': instance.category_id,
      'description': instance.description,
      'is_new': instance.is_new,
      'rate': instance.rate,
      'quantity': instance.quantity,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailsModel _$ProductDetailsModelFromJson(Map<String, dynamic> json) {
  return ProductDetailsModel(
    how_get_size: json['how_get_size'],
    variations: (json['variations'] as List<dynamic>?)
        ?.map((e) => VariationModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    category_id: json['category_id'] as int,
    name: json['name'] as String,
    id: json['id'] as int,
    type: json['type'],
    isFavorite: json['isFavorite'] as bool,
    price: json['price'],
    product_as_same: (json['product_as_same'] as List<dynamic>?)
        ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    description: json['description'],
    discount_type: json['discount_type'],
    discount_price: json['discount_price'],
    isReview: json['isReview'],
    is_new: json['is_new'],
    image: json['image'],
    review_count: json['review_count'],
    quantity: json['quantity'],
    rate: json['rate'],
  );
}

Map<String, dynamic> _$ProductDetailsModelToJson(
        ProductDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'discount_type': instance.discount_type,
      'discount_price': instance.discount_price,
      'product_as_same': instance.product_as_same,
      'rate': instance.rate,
      'review_count': instance.review_count,
      'isReview': instance.isReview,
      'rate': instance.rate,
      'type': instance.type,
      'isFavorite': instance.isFavorite,
      'description': instance.description,
      'category_id': instance.category_id,
      'variations': instance.variations,
      'how_get_size': instance.how_get_size
    };

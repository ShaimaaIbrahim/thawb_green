import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/models/base_model.dart';
import 'package:ojos_app/features/product/data/models/general_item_model.dart';
import 'package:ojos_app/features/product/data/models/image_info_model.dart';
import 'package:ojos_app/features/product/data/models/item_model.dart';
import 'package:ojos_app/features/product/data/models/product_info_item_model.dart';
import 'package:ojos_app/features/product/domin/entities/item_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';

import 'review_model.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends BaseModel<ProductEntity> {
  final int? id;
  final int? category_id;
  final String? name;
  final int? price;
  final int? quantity;
  final String? discount_type;
  final dynamic discount_price;
  final String? image;
  final bool? is_new;
  final String? description;
  final String? rate;
  final bool? isReview;
  final bool? isFavorite;
  final int? review_count;
  List<ProductEntity> product_as_same;

  ProductModel({
    required this.category_id,
    required this.name,
    required this.id,
    required this.price,
    required this.discount_price,
    required this.description,
    required this.is_new,
    required this.rate,
    required this.image,
    required this.quantity,
    required this.discount_type,
    required this.isReview,
    required this.product_as_same,
    required this.review_count,
    required this.isFavorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  ProductEntity toEntity() => ProductEntity(
      id: this.id,
      name: this.name,
      category_id: this.category_id,
      discount_type: this.discount_type,
      discount_price: this.discount_price,
      description: this.description,
      isFavorite: this.isFavorite,
      isReview: this.isReview,
      is_new: this.is_new,
      image: this.image,
      rate: this.rate,
      review_count: this.review_count,
      price: this.price,
      product_as_same: this.product_as_same,
      quantity: this.quantity,
      length_id: '',
      color_id: '',
      size_id: '',
      fabric_id: '', note: '');
}

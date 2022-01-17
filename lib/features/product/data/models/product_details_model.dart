import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ojos_app/core/models/base_model.dart';
import 'package:ojos_app/features/product/data/models/general_item_model.dart';
import 'package:ojos_app/features/product/data/models/image_info_model.dart';
import 'package:ojos_app/features/product/data/models/item_model.dart';
import 'package:ojos_app/features/product/data/models/product_info_item_model.dart';
import 'package:ojos_app/features/product/data/models/product_model.dart';
import 'package:ojos_app/features/product/data/models/variation_model.dart';
import 'package:ojos_app/features/product/domin/entities/item_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';

import 'review_model.dart';

part 'product_details_model.g.dart';

@JsonSerializable()
class ProductDetailsModel extends BaseModel<ProductDetailsEntity> {
  final int id;
  final int category_id;
  final String name;
  final int price;
  final int? quantity;
  final String? discount_type;
  final int? discount_price;
  final String image;
  final bool is_new;
  final String? description;
  final String rate;
  final bool isReview;
  final bool isFavorite;
  final int review_count;
  final String type;
  final String? how_get_size;
  List<ProductModel>? product_as_same;
  List<VariationModel>? variations;

  ProductDetailsModel(
      {required this.category_id,
      required this.how_get_size,
      required this.type,
      required this.name,
      required this.id,
      required this.price,
      required this.description,
      required this.is_new,
      required this.rate,
      required this.image,
      required this.quantity,
      required this.discount_price,
      required this.discount_type,
      required this.isReview,
      required this.product_as_same,
      required this.review_count,
      required this.isFavorite,
      required this.variations});

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsModelToJson(this);

  @override
  ProductDetailsEntity toEntity() => ProductDetailsEntity(
      id: this.id,
      name: this.name,
      category_id: this.category_id,
      image: this.image,
      is_new: this.is_new,
      isFavorite: this.isFavorite,
      isReview: this.isReview,
      price: this.price,
      type: this.type,
      product_as_same: this.product_as_same != null
          ? this.product_as_same!.map((t) => t.toEntity()).toList()
          : [],
      discount_price: this.discount_price ?? 0,
      discount_type: this.discount_type ?? '',
      description: this.description ?? '',
      quantity: this.quantity ?? 0,
      rate: this.rate,
      review_count: this.review_count,
      variations: this.variations != null ? this.variations!.toList() : [], how_get_size: this.how_get_size ?? '');
}

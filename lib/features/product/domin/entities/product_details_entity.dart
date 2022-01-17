import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/entities/base_entity.dart';
import 'package:ojos_app/features/home/data/models/product_model.dart';
import 'package:ojos_app/features/product/data/models/product_model.dart';
import 'package:ojos_app/features/product/data/models/variation_model.dart';

import 'general_item_entity.dart';
import 'image_info_entity.dart';
import 'item_entity.dart';
import 'product_entity.dart';
import 'review_entity.dart';

class ProductDetailsEntity extends BaseEntity {
  final int id;
  final int category_id;
  final String name;
  final int price;
  final int quantity;
  final String discount_type;
  final int discount_price;
  final String image;
  final bool is_new;
  final String description;
  final String rate;
  final bool isReview;
  bool isFavorite;
  final int review_count;
  final String type;
  final String how_get_size;
  List<ProductEntity> product_as_same;
  List<VariationModel>? variations;

  ProductDetailsEntity( {
    required this.how_get_size,
    required this.type,
    required this.category_id,
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
    required this.variations
  });

  @override
  List<Object> get props => [
        category_id,
        name,
        id,
        price,
        description,
        rate,
        isFavorite,
      ];
}

import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/entities/base_entity.dart';
import 'package:ojos_app/features/product/domin/entities/review_entity.dart';

import 'general_item_entity.dart';
import 'image_info_entity.dart';
import 'item_entity.dart';

class ProductEntity extends BaseEntity {
  final int? id;
  final int? category_id;
  final String? name;
  int? price;
  final int? quantity;
  final String? discount_type;
  int discount_price;
  final String? image;
  final bool? is_new;
  final String? description;
  final String? rate;
  final bool? isReview;
  final bool? isFavorite;
  final int? review_count;
  final String? fabric_id;
  final String? color_id;
  final String? size_id;
  String? note;
  final String? length_id;
  List<ProductEntity>? product_as_same;

  ProductEntity({
    required this.note,
    required this.fabric_id,
    required this.color_id,
    required this.size_id,
    required this.length_id,
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
  });

  @override
  List<Object> get props => [];
}

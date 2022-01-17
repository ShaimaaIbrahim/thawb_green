import 'package:flutter/foundation.dart';
import 'package:ojos_app/core/entities/base_entity.dart';
import 'package:ojos_app/features/product/domin/entities/general_item_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';

class ProductInfoItemEntity extends BaseEntity {
  final int? id;
  final int? category_id;
  final String? name;
  final int? price;
  final int? quantity;
  final String? discount_type;
  final int? discount_price;
  final String? image;
  final bool? is_new;
  final String? description;
  final double? rate;
  final bool? isReview;
  final bool? isFavorite;
  final int? review_count;
  List<ProductEntity>? product_as_same;

  ProductInfoItemEntity({
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

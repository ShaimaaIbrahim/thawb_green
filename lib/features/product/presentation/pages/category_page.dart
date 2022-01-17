// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.status,
    required this.msg,
    required this.result,
  });

  bool status;
  String msg;
  List<Result> result;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        status: json["status"],
        msg: json["msg"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discountType,
    required this.discountPrice,
    required this.image,
    required this.isNew,
    required this.description,
    required this.brandId,
    required this.rate,
    required this.isReview,
    required this.isFavorite,
    required this.reviewCount,
    required this.productReviews,
  });

  int id;
  int categoryId;
  String name;
  int price;
  dynamic quantity;
  String discountType;
  int discountPrice;
  String image;
  bool isNew;
  String description;
  int brandId;
  String rate;
  bool isReview;
  bool isFavorite;
  int reviewCount;
  List<dynamic> productReviews;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        discountType: json["discount_type"],
        discountPrice: json["discount_price"],
        image: json["image"],
        isNew: json["is_new"],
        description: json["description"],
        brandId: json["brand_id"],
        rate: json["rate"],
        isReview: json["isReview"],
        isFavorite: json["isFavorite"],
        reviewCount: json["review_count"],
        productReviews:
            List<dynamic>.from(json["product_reviews"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "price": price,
        "quantity": quantity,
        "discount_type": discountType,
        "discount_price": discountPrice,
        "image": image,
        "is_new": isNew,
        "description": description,
        "brand_id": brandId,
        "rate": rate,
        "isReview": isReview,
        "isFavorite": isFavorite,
        "review_count": reviewCount,
        "product_reviews": List<dynamic>.from(productReviews.map((x) => x)),
      };
}

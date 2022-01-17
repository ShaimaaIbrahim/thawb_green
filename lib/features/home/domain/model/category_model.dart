// To parse this JSON data, do
//
//     final generalCategoryModel = generalCategoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GeneralCategoryModel generalCategoryModelFromJson(String str) =>
    GeneralCategoryModel.fromJson(json.decode(str));

String generalCategoryModelToJson(GeneralCategoryModel data) =>
    json.encode(data.toJson());

class GeneralCategoryModel {
  GeneralCategoryModel({
    required this.status,
    required this.msg,
    required this.result,
  });

  bool status;
  String msg;
  List<CategoryResult> result;

  factory GeneralCategoryModel.fromJson(Map<String, dynamic> json) =>
      GeneralCategoryModel(
        status: json["status"],
        msg: json["msg"],
        result: List<CategoryResult>.from(
            json["result"].map((x) => CategoryResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class CategoryResult {
  CategoryResult({
    required this.id,
    required this.name,
    required this.image,
  });

  int id;
  String name;
  String image;

  factory CategoryResult.fromJson(Map<String, dynamic> json) => CategoryResult(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

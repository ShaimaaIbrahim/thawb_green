import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/features/home/data/models/product_model.dart';
import 'package:ojos_app/features/home/domain/model/category_model.dart';
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/others/data/models/about_app_result_model.dart';

Dio dio = Dio();

class HomePageApi {
  StreamController? productController;

  Future<GeneralProductModel>? feachProduct(int categoryId) async {
    Response response = await dio.get(productUrl(categoryId));
    if (response.statusCode == 200) {
      return GeneralProductModel.fromJson(response.data);
    } else {
      return GeneralProductModel.fromJson({});
    }
  }

  // loadProductStream(id) {
  //   feachProduct(id)!.then((res) async {
  //     productController!.add(res);
  //     return res;
  //   });
  // }

  Future<GeneralCategoryModel?>? feachCategory() async {
    Response response = await dio.get(categoryUrl);
    if (response.statusCode == 200) {
      return GeneralCategoryModel.fromJson(response.data);
    }
    return GeneralCategoryModel.fromJson({});
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/features/home/domain/model/category_model.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/wallet/model/wallet_model.dart';

Dio dio = Dio();

class WalletPageApi {
  var _cancelToken=CancelToken();
  StreamController? walletController;

  Future<WalletResponse>? fetchWalletData() async {
    try {
      CancelToken cancelToken = CancelToken();
      // Specify the headers.
      final Map<String, dynamic> headers = {};

      // Get the language.
      final lang = await appConfig.currentLanguage;

      headers.putIfAbsent(HEADER_LANGUAGE, () => lang);
      headers.putIfAbsent(HEADER_CONTENT_TYPE, () => 'application/json');
      headers.putIfAbsent(HEADER_ACCEPT, () => 'application/json');
      if (await UserRepository.hasToken) {
        final token = await UserRepository.authToken;
        headers.putIfAbsent(HEADER_AUTH, () => 'Bearer $token');
      }
      Response response = await Dio().get(
        API_WALLET,
        queryParameters: {},
        //  data: data,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      print(response.toString());
      if (response.statusCode == 200) {
        return WalletResponse.fromJson(response.data);
      } else {
        return WalletResponse.fromJson({});
      }
    }
    // Handling errors
    on DioError catch (e) {
      print('Exception is DioError $e');
      print('Exception is DioError message ${e.message}');
      print(
          'Exception is DioError requestOptions.headers ${e.requestOptions.headers}');
      print('Exception is DioError error ${e.error}');
      print('Exception is DioError request.data ${e.requestOptions.data}');
      print('Exception is DioError path ${e.requestOptions.path}');
      print('Exception is DioError response ${e.response}');
      return WalletResponse.fromJson({});
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

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/features/cart/domin/entities/cart_attribute_entity.dart';
import 'package:ojos_app/features/cart/presentation/args/cart_page_tafsil_args.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';

class CartApi {
  Future<bool> completeOrderOnline(CartAttributeEntity entity, {String? phone, int? method_id, String? delivery_fee,
    String? tax } ) async {
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
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      var data = {
        "order_date": formatted,
        "method_id": method_id,
        "subtotal": 0,
        "discount": entity.discountPrice,
        "tax": tax,
        "total": 0,
        "delivery_fee": delivery_fee,
        "neck_length": entity.neck,
        "cupcake": entity.hand,
        // "colour_id": 37,
        // "size_id": 303,
        // "length_id": 304,
        "name": entity.name,
        "phone": phone,
        "visiting": "fsdfsd",
        "count_item": 1,
        "length": entity.length,
        "waist": entity.waist,
        "chest": 0,
        "shoulder": entity.shoulder,
        "hand": entity.hand,
        "neck": entity.neck,
        "armpit": entity.bat,
        "elbow": entity.elbow,
        "gypsour": entity.jisor,
        "step": entity.step,
        "pocket_type": entity.geepTypeValue,
        "type_hand": entity.handTypeValue,
        // "tailor_id": 69,
        // "model_id": 78,
        "pocket_id": entity.geepTypeValue,
        "acctype_id": entity.zraierTypeValue,
        "fabric_id": 259,
        "accnum_id": 263,
       "addition_id": 265,
        "collar_id": entity.yakaTypeValue,
        "gypsour_id": entity.geepTypeValue,
      //  "filling_type_id": 300,
        "note": entity.notes
      };
      Response response = await Dio().post(
        orders_post_orderOnlines,
        queryParameters: {},
        data: data,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      if(response.statusCode==200){
        return true;
    }
      print('Dio Success Response ${response.data}');
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
    }
    return false;
  }
}

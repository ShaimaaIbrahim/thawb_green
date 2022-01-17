// orders_attributes
// OrderAttributeModel

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/features/order/data/models/custom_order.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';

Dio dio = Dio();

Future<OrderAttributeModel>? feachOrderAttribute() async {
  Response response = await dio.get(orders_attributes);
  if (response.statusCode == 200) {
    print(response.data);
    return OrderAttributeModel.fromJson(response.data);
  } else {
    return OrderAttributeModel.fromJson({});
  }
}

Future storeOrder(context,
    {required String order_date,
    required String name,
    required String phone,
    required String address,
    required int count_item,
    required int length,
    // required int waist,
    required int chest,
    required int shoulder,
    required int hand,
    required int neck,
    required int armpit,
    required int elbow,
    required int gypsour,
    required int step,
    required int pocket_type,
    required int type_hand,
    required int tailor_id,
    required int model_id,
    required int pocket_id,
    required int acctype_id,
    // required int fabric_id,
    // required int accnum_id,
    // required int addition_id,
    //  required int embroidery_id,  ******* تطريز سليم   *******************
    required int collar_id,
    required String visiting,
    required String note,
    required int gypsourtype,
    required int fillingtype}) async {
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
    Response response = await Dio().post(
      orders_post_orderOnlines,
      queryParameters: {},
      data: {
        "name": name,
        "phone": phone,
        'fabric_id': 0,
        "address": address,
        "order_date": order_date,
        "visiting": visiting,
        "count_item": count_item,
        "length": length,
        "chest": chest,
        "shoulder": shoulder,
        "hand": hand,
        "neck": neck,
        "armpit": armpit,
        "elbow": elbow,
        "gypsour": gypsour,
        "step": step,
        "pocket_type": pocket_type,
        "type_hand": type_hand,
        "tailor_id": tailor_id,
        "pocket_id": pocket_id,
        "acctype_id": acctype_id,
        "collar_id": collar_id,
        "gypsour_id": gypsourtype,
        "filling_type_id": fillingtype,
        "note": note
      },
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "تم الطلب بنجاح",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response);
    } else {
      Fluttertoast.showToast(
          msg: "يرجي المحاولة في وقت اخر",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
  }
}

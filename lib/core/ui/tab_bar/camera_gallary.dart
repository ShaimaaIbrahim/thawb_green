import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/features/bill_photos/data/response/bill_response.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';

import '../../appConfig.dart';
import '../../constants.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImagePickerState();
  }
}

class _ImagePickerState extends State<ImagePickerWidget> {
  String? _imgPath;
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _imgPath ==null ?  Container() :_ImageView(_imgPath),
            SizedBox(
              height: 25.h,
            ),
            _imgPath == null
                ? Column(
                    children: [
                      RaisedButton(
                        onPressed: _takePhoto,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('صـورة'),
                            SizedBox(
                              width: 8.w,
                            ),
                            Icon(Icons.camera_alt),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      RaisedButton(
                        onPressed: _openGallery,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('حـدد صـورة'),
                            SizedBox(
                              width: 8.w,
                            ),
                            Icon(Icons.photo_library),
                          ],
                        ),
                      ),
                    ],
                  )
                : RaisedButton(
                    onPressed: _uploadImageToApi,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('رفع الصورة'),
                        SizedBox(
                          width: 8.w,
                        ),
                        Icon(Icons.arrow_upward_sharp),
                      ],
                    ),
                  ),
            SizedBox(
              height: 25.h,
            ),
          ],
        ),
      ),
    ));
  }

  _uploadImageToApi() async {
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
      String fileName = imageFile!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "invoice":
            await MultipartFile.fromFile(imageFile!.path, filename: fileName),
      });

      Response response = await Dio().post(
        API_INVOICE,
        queryParameters: {},
        data: formData,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      setState(() {
        _imgPath = null;
      });
      print('picture uploaded successfully ${response.statusCode}');

      // return BillResponse.fromJson(response.data);
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
      //  return BillResponse.fromJson({});
    }
  }

  // / * التحكم بالصورة * /
  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return Center(
        child: Text(
          Translations.of(context).translate('bill_head'),
          style: textStyle.bigTSBasic.copyWith(
            color: globalColor.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return Image.file(
        File(imgPath),
      );
    }
  }

//التقط صوره

  _takePhoto() async {
    var image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image!.path;
      imageFile = image;
    });
  }

  // / * ألبوم * /
  _openGallery() async {
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgPath = image!.path;
      imageFile = image;
    });
  }
}

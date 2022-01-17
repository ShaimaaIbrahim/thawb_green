import 'package:clippy_flutter/arc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/localization/translations_delegate.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/items_shimmer/base_shimmer.dart';
import 'package:ojos_app/features/bill_photos/data/response/invoices_response.dart';
import 'package:ojos_app/features/bill_photos/image_viewr_page.dart';
import 'package:ojos_app/features/bill_photos/widget/BuildGridBillPhotosWidget.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:get/get.dart' as Get;


class PillPhotosPage extends StatefulWidget {
  static const String routeName = "/screens/pillphoptos_page";

  const PillPhotosPage({Key? key}) : super(key: key);

  @override
  _PillPhotosPageState createState() => _PillPhotosPageState();
}

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
var _cancelToken = CancelToken();

Future<List<Data>?>? invoices;

class _PillPhotosPageState extends State<PillPhotosPage> {
  @override
  void initState() {
    _getInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('pill_photos'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery
            .of(context)
            .viewPadding
            .top;

    return Scaffold(
        appBar: appBar,
        body: Container(
          width: width,
          height: height,
          child: FutureBuilder(
            future: _getInvoices(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Data>?> snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      Translations.of(context).translate('no_invoices'),
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  );
                } else {
                  return GridView.builder(
                    itemCount: data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio:
                      globalSize.setWidthPercentage(43, context) /
                          globalSize.setWidthPercentage(60, context),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Get.Get.toNamed(ImageViewrPage.routeName, arguments: data);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.w),
                          width: globalSize.setWidthPercentage(43, context),
                          height: globalSize.setWidthPercentage(60, context),
                          child: Image.network(data[index].invoice!),
                        ),
                      );
                    },
                  );
                }
              }
              return GridView.builder(
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio:
                  globalSize.setWidthPercentage(43, context) /
                      globalSize.setWidthPercentage(60, context),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return BaseShimmerWidget(
                    child: Container(
                      margin: EdgeInsets.all(10.w),
                      width: globalSize.setWidthPercentage(43, context),
                      height: globalSize.setWidthPercentage(60, context),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }

  Future<List<Data>?> _getInvoices() async {
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
        API_INVOICE,
        queryParameters: {},
        //  data: data,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      // invoices =  InvoicesResponse.fromJson(response.data).data;
      return InvoicesResponse
          .fromJson(response.data)
          .data;
    }
    // Handling errors
    on DioError catch (e) {
      print('Exception is DioError $e');
      print('Exception is DioError message ${e.message}');
      print(
          'Exception is DioError requestOptions.headers ${e.requestOptions
              .headers}');
      print('Exception is DioError error ${e.error}');
      print('Exception is DioError request.data ${e.requestOptions.data}');
      print('Exception is DioError path ${e.requestOptions.path}');
      print('Exception is DioError response ${e.response}');
      return InvoicesResponse
          .fromJson({})
          .data;
    }
  }
}

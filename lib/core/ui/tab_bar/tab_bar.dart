import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/features/order/presentation/pages/attripute.dart';
import 'package:share/share.dart';

import 'camera_gallary.dart';

class TabBarDemo extends StatefulWidget {
  final int? price;
  final int? discountPrice;
  final String? name;
  final String? image;
  final int? id;

  const TabBarDemo({Key? key, this.price, this.discountPrice, this.name, this.id, required this.image}) : super(key: key);
  @override
  State<TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: globalColor.appBar,
          brightness: Brightness.light,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'ادخل مقاسك',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'اطلب الخياط',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'صورة الفاتورة',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "طلب اون لاين",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            OrderAttribute(
              price: widget.price,
              discountPrice: widget.discountPrice,
              name: widget.name, image: widget.image,
            ),
            Column(       //********************************* اطلب الخياط***************************************
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  Translations.of(context)
                      .translate('tailor_head'),
                  style: textStyle
                      .bigTSBasic
                      .copyWith(
                    color: globalColor.primaryColor,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
                Text(
                  Translations.of(context)
                      .translate('tailor_text'),
                  style: textStyle
                      .subBigTSBasic
                      .copyWith(
                    color: Colors.black,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                HorizontalPadding(
                    percentage: 2),
                OutlineButton(
                  borderSide: BorderSide(
                    width: .5,
                    color: Colors.black,
                    style:
                    BorderStyle.solid,
                  ),
                  shape:
                  RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          8)),
                  onPressed: () {
                    launchWhatsApp(
                        phone:
                        "+966555845631",
                        message:
                        "مرحبا اريد تفصيل ثوب");
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [
                      Text(
                        Translations.of(
                            context)
                            .translate(
                            'near'),
                        style: textStyle
                            .normalTSBasic
                            .copyWith(
                          fontSize: 22,
                          color:
                          globalColor
                              .grey,
                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Image.asset(
                        'assets/images/icons/png/whats.png',
                        height: 30.h,
                        width: 30.w,
                      )
                    ],
                  ),
                ),
                HorizontalPadding(
                    percentage: 2),
              ],
            ),
            ImagePickerWidget(),
          ],
        ),
      ),
    );
  }
}
void launchWhatsApp({
  required String phone,
  required String message,
}) async {
  String url() {
    if (Platform.isAndroid) {
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(
          message)}"; // new line
    }
  }
  Share.share(url(), subject: message);

}
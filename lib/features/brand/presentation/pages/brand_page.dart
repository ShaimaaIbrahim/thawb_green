import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/list/build_list_brand.dart';

import 'package:dio/dio.dart';

class BrandPage extends StatefulWidget {
  static const routeName = '/brand/pages/BrandPage';

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  void initState() {
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    //=========================================================================

    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('brand'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double widthC = globalSize.setWidthPercentage(100, context);
    double heightC = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
        appBar: appBar,
        key: _scaffoldKey,
        body: Container(
            child: BuildListBrandWidget(
          params: {},
          cancelToken: _cancelToken,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: globalSize.setWidthPercentage(28, context) /
                globalSize.setWidthPercentage(40, context),
          ),
        )));
  }

  /* _buildSearchWidget({BuildContext context, double width}) {
    return Padding(
      padding: const EdgeInsets.all(EdgeMargin.small),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.circular(12.0.w),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: Icon(
                          EvilIcons.search,
                          size: 28.w,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.h,
                    color: globalColor.grey.withOpacity(0.2),
                    width: .5,
                  )
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: TextField(
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: Translations.of(context).translate('Find_your_product_here'),
                      hintStyle: textStyle.smallTSBasic
                          .copyWith(color: globalColor.grey)),
                )),
            // Expanded(
            //   flex: 1,
            //   child: Row(
            //     children: [
            //       Container(
            //         height: 50.h,
            //         color: globalColor.grey.withOpacity(0.2),
            //         width: .5,
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: SvgPicture.asset(
            //           AppAssets.filter,
            //           width: 22,
            //           height: 22,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }*/
  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}

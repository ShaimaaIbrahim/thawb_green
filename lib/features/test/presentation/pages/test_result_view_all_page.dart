import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ojos_app/core/errors/bad_request_error.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/errors/custom_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/list/build_list_product.dart';
import 'package:ojos_app/core/ui/widget/button/rounded_button.dart';
import 'package:ojos_app/core/ui/widget/general_widgets/error_widgets.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/features/product/data/models/product_model.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/blocs/brands_bloc.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_home_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_widget.dart';
import 'package:ojos_app/features/test/presentation/blocs/test_bloc.dart';

class TestResultVeiwAllPage extends StatefulWidget {
  static const routeName = '/test/pages/TestResultVeiwAllPage';

  @override
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultVeiwAllPage> {
  final args = Get.Get.arguments as List<ProductEntity>;

  @override
  void initState() {
    super.initState();
  }

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
        Translations.of(context).translate('the_result'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
        appBar: appBar,
        backgroundColor: globalColor.scaffoldBackGroundGreyColor,
        body: Container(
          height: height,
          child: args != null && args.isNotEmpty
              ? Container(
                  height: globalSize.setWidthPercentage(60, context),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: args.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio:
                            globalSize.setWidthPercentage(43, context) /
                                globalSize.setWidthPercentage(60, context),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return ItemProductHomeWidget(
                          width: globalSize.setWidthPercentage(43, context),
                          height: globalSize.setWidthPercentage(60, context),
                          product: args[index],
                          fromHome: true,
                        );
                      }))
              : Container(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

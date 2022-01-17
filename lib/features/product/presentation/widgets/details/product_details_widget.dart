import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/providers/cart_provider.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/hex_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/dailog/add_to_cart_dialog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/dailog/soon_dailog.dart';
import 'package:ojos_app/core/ui/tab_bar/tab_bar.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/core/ui/widget/text/normal_form_field.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/core/validators/required_validator.dart';
import 'package:ojos_app/features/cart/domin/entities/cart_attribute_entity.dart';
import 'package:ojos_app/features/cart/presentation/args/cart_page_gahez_args.dart';
import 'package:ojos_app/features/cart/presentation/args/cart_page_tafsil_args.dart';
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/order/domain/entities/video_player_args.dart';
import 'package:ojos_app/features/others/presentation/pages/sub_pages/terms_condetion.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
import 'package:ojos_app/features/product/domin/entities/image_info_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
import 'package:ojos_app/features/product/domin/usecases/add_remove_favorite.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/args/select_lenses_args.dart';
import 'package:ojos_app/features/product/presentation/pages/video_player_video.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_color_product.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_product_widget.dart';
import 'package:ojos_app/features/product/presentation/widgets/item_size_product.dart';
import 'package:ojos_app/features/product/presentation/widgets/select_lenses_page.dart';
import 'package:ojos_app/features/reviews/presentation/pages/add_reviews_page.dart';
import 'package:ojos_app/features/search/presentation/widgets/item_size_filter.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/widgets/user_management_text_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../main.dart';
import '../../../domin/entities/general_item_entity.dart';
import '../item_color_product_details.dart';
import '../item_product_home_widget.dart';
import '../item_size_product_details.dart';

final _formKey = GlobalKey<FormState>();

class ProductDetailsWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final OffersAndDiscount product;
  final ProductDetailsEntity productDetails;
  final CancelToken cancelToken;

  const ProductDetailsWidget(
      {required this.height,
      required this.width,
      required this.product,
      required this.productDetails,
      required this.cancelToken});

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {


  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var currentPageValue = 0;

  /// frame Height parameters
  bool _frameHeightValidation = false;
  String _frameHeight = '';
  final TextEditingController frameHeightEditingController =
      new TextEditingController();

  /// frame Width parameters
  bool _frameWidthValidation = false;
  String _frameWidth = '';
  final TextEditingController frameWidthEditingController =
      new TextEditingController();

  /// frame Length parameters
  bool _frameLengthValidation = false;
  String _frameLength = '';
  final TextEditingController frameLengthEditingController =
      new TextEditingController();
  bool? isAuth;

  //SelectLensesArgs? selectLensesArgs;

  bool _isDisplaySizeList = true;

  List<int>? listOfColorSelected;

  GeneralItemEntity? color;
  List<int>? listOfSizeMode;
  List<bool> selectsColors = [];
  List<bool> selectsTypes = [];
  List<bool> selectsSizes = [];
  List<bool> selectsLenghts = [];
  String? length;
  String? selectedColor;
  String? type;
  String? size;

  TextEditingController noteEditingController = TextEditingController();
  TextEditingController lengthEditiingValue = TextEditingController();
  bool _noteValidation = false;
  String _note = "";

  bool _lengthValidation = false;
  String _length = "";
  int? SizeModeId;

  @override
  void initState() {
    super.initState();
    listOfColorSelected = [];
    listOfSizeMode = [];
    for (int i = 0; i < widget.productDetails.variations!.length; i++) {
      selectsColors.add(false);
      selectsLenghts.add(false);
      selectsTypes.add(false);
      selectsSizes.add(false);
    }

    color = null;
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? globalSize.setWidthPercentage(100, context);
    final height =
        widget.height ?? globalSize.setHeightPercentage(100, context);

    isAuth =
        BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
            BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: globalColor.white,
              // borderRadius: BorderRadius.all(Radius.circular(12.w))
            ),
            child: Column(
              children: [
                _buildTopWidget(
                    context: context,
                    width: width,
                    height: height,
                    discountPrice: widget.product.discount_price,
                    discountType: widget.productDetails.discount_type,
                    product: widget.productDetails),
                _buildTitleAndPriceWidget(
                  context: context,
                  width: width,
                  height: height,
                  price: widget.product.price,
                  priceAfterDiscount: widget.product.discount_price,
                  discountPrice: widget.product.discount_price,
                  discountType: widget.productDetails.discount_type,
                  name: widget.productDetails.name,
                ),
                _divider(),
                Visibility(
                  visible: widget.productDetails.type == 'جاهز' ||
                          widget.productDetails.type == 'جاهز 3'
                      ? false
                      : true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          " ",
                          style: textStyle.middleTSBasic.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Get.Get.toNamed(VideoPlayerVideo.routeName,
                                arguments: VideoPlayerArgs(
                                    videoUrl:
                                        widget.productDetails.how_get_size));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "تعرف بأخذ قياسك",
                                style: textStyle.smallTSBasic.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Icon(
                                Icons.arrow_back_ios_new_sharp,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.productDetails.type == 'جاهز' ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "الألوان",
                              style: textStyle.middleTSBasic.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                          height: 60.h,
                          child: ListView.builder(
                              itemCount:
                                  widget.productDetails.variations!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectsColors[index] =
                                              !selectsColors[index];
                                          selectedColor = widget.productDetails
                                              .variations![index].clothColor;
                                        });
                                      },
                                      child: Container(
                                        height: 30.w,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            color: HexColor(widget
                                                    .productDetails
                                                    .variations![index]
                                                    .clothColor ??
                                                ''),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.w)),
                                            border: Border.all(
                                                color:
                                                    selectsColors[index] == true
                                                        ? Colors.green
                                                        : Colors.grey,
                                                width: 2.w)),
                                      ),
                                    ));
                              })),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "المقاسات",
                              style: textStyle.middleTSBasic.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 60.h,
                          child: ListView.builder(
                              itemCount:
                                  widget.productDetails.variations!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return widget.productDetails.variations![index]
                                            .clothSize !=
                                        null
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectsSizes[index] =
                                                !selectsSizes[index];
                                            size = widget.productDetails
                                                .variations![index].clothSize;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10.w),
                                          child: Container(
                                            height: 40,
                                            // width: 40,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.w)),
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color:
                                                        selectsSizes[index] ==
                                                                true
                                                            ? Colors.green
                                                            : Colors.grey,
                                                    width: 2.w)),
                                            child: Padding(
                                              padding: EdgeInsets.all(4.w),
                                              child: Center(
                                                child: Text(
                                                  widget
                                                          .productDetails
                                                          .variations![index]
                                                          .clothSize ??
                                                      '',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                              })),
                      // SizedBox(
                      //   height: 8.h,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         "الطول",
                      //         style: textStyle.middleTSBasic.copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //         textAlign: TextAlign.start,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "نوع القماش",
                              style: textStyle.middleTSBasic.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        height: 60.h,
                        child: ListView.builder(
                            itemCount: widget.productDetails.variations!.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return widget.productDetails.variations![index]
                                          .clothType !=
                                      null
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectsTypes[index] =
                                              !selectsTypes[index];
                                          type = widget.productDetails
                                              .variations![index].clothType;
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.w),
                                        child: Container(
                                          height: 30.h,
                                          //width: 70.w,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.w)),
                                              border: Border.all(
                                                  color: selectsTypes[index] ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  width: 2.w)),
                                          child: Padding(
                                            padding: EdgeInsets.all(4.w),
                                            child: Center(
                                              child: Text(
                                                widget
                                                        .productDetails
                                                        .variations![index]
                                                        .clothType ??
                                                    '',
                                                style:
                                                    TextStyle(fontSize: 13.sp),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: EdgeMargin.min, right: EdgeMargin.min),
                        child: NormalOjosTextFieldWidget(
                          controller: lengthEditiingValue,
                          maxLines: 1,
                          filled: true,
                          style: textStyle.smallTSBasic.copyWith(
                              color: globalColor.black,
                              fontWeight: FontWeight.bold),
                          contentPadding: const EdgeInsets.fromLTRB(
                            EdgeMargin.small,
                            EdgeMargin.middle,
                            EdgeMargin.small,
                            EdgeMargin.small,
                          ),
                          fillColor: globalColor.white,
                          backgroundColor: globalColor.white,
                          labelBackgroundColor: globalColor.white,
                          // validator: (value) {
                          //   return BaseValidator.validateValue(
                          //     context,
                          //     value!,
                          //     [],
                          //     _lengthValidation,
                          //   );
                          // },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return Translations.of(
                                  context)
                                  .translate(
                                  'Please enter some text');
                            }
                            return null;
                          },
                          hintText: Translations.of(context)
                              .translate('write_your_length'),
                          label: Translations.of(context)
                              .translate('write_your_length'),
                          keyboardType: TextInputType.text,
                          borderRadius: width * .02,
                          onChanged: (value) {
                            setState(() {
                              _lengthValidation = true;
                              _length = value;
                            });
                          },
                          borderColor: globalColor.grey.withOpacity(0.3),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: EdgeMargin.min, right: EdgeMargin.min),
                        child: NormalOjosTextFieldWidget(
                          controller: noteEditingController,
                          maxLines: 1,
                          filled: true,
                          style: textStyle.smallTSBasic.copyWith(
                              color: globalColor.black,
                              fontWeight: FontWeight.bold),
                          contentPadding: const EdgeInsets.fromLTRB(
                            EdgeMargin.small,
                            EdgeMargin.middle,
                            EdgeMargin.small,
                            EdgeMargin.small,
                          ),
                          fillColor: globalColor.white,
                          backgroundColor: globalColor.white,
                          labelBackgroundColor: globalColor.white,
                          // validator: (value) {
                          //   return BaseValidator.validateValue(
                          //     context,
                          //     value!,
                          //     [],
                          //     _noteValidation,
                          //   );
                          // },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return Translations.of(
                                  context)
                                  .translate(
                                  'Please enter some text');
                            }
                            return null;
                          },
                          hintText: Translations.of(context)
                              .translate('write_your_notes'),
                          label:
                              Translations.of(context).translate('add_notes'),
                          keyboardType: TextInputType.text,
                          borderRadius: width * .02,
                          onChanged: (value) {
                            setState(() {
                              _noteValidation = true;
                              _note = value;
                            });
                          },
                          borderColor: globalColor.grey.withOpacity(0.3),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible:
                      widget.productDetails.type == 'جاهز 3' ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "الألوان",
                              style: textStyle.middleTSBasic.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                          height: 60.h,
                          child: ListView.builder(
                              itemCount:
                                  widget.productDetails.variations!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectsColors[index] =
                                              !selectsColors[index];
                                          selectedColor = widget.productDetails
                                              .variations![index].clothColor;
                                        });
                                      },
                                      child: Container(
                                        height: 30.w,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            color: HexColor(widget
                                                    .productDetails
                                                    .variations![index]
                                                    .clothColor ??
                                                ''),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.w)),
                                            border: Border.all(
                                                color:
                                                    selectsColors[index] == true
                                                        ? Colors.green
                                                        : Colors.grey,
                                                width: 2.w)),
                                      ),
                                    ));
                              })),
                      SizedBox(
                        height: 8.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "المقاسات",
                              style: textStyle.middleTSBasic.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Container(
                          height: 60.h,
                          child: ListView.builder(
                              itemCount:
                                  widget.productDetails.variations!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectsSizes[index] =
                                          !selectsSizes[index];
                                      size = widget.productDetails
                                          .variations![index].clothSize;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.w)),
                                          color: Colors.grey[200],
                                          border: Border.all(
                                              color: selectsSizes[index] == true
                                                  ? Colors.green
                                                  : Colors.grey,
                                              width: 2.w)),
                                      child: Center(
                                        child: Text(
                                          widget
                                                  .productDetails
                                                  .variations![index]
                                                  .clothSize ??
                                              '',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
                      // SizedBox(
                      //   height: 8.h,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         "الطول",
                      //         style: textStyle.middleTSBasic.copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //         textAlign: TextAlign.start,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         "نوع القماش",
                      //         style: textStyle.middleTSBasic.copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.bold),
                      //         textAlign: TextAlign.start,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 5.h,
                      // ),
                      // Container(
                      //   height: 60.h,
                      //   child: ListView.builder(
                      //       itemCount: widget.productDetails.variations!.length,
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return InkWell(
                      //           onTap: () {
                      //             setState(() {
                      //               selectsTypes[index] = !selectsTypes[index];
                      //               type = widget.productDetails
                      //                   .variations![index].clothType;
                      //             });
                      //           },
                      //           child: Padding(
                      //             padding: EdgeInsets.all(10.w),
                      //             child: Container(
                      //               height: 30.h,
                      //               //width: 70.w,
                      //               decoration: BoxDecoration(
                      //                   color: Colors.grey[200],
                      //                   borderRadius: BorderRadius.all(
                      //                       Radius.circular(5.w)),
                      //                   border: Border.all(
                      //                       color: selectsTypes[index] == true
                      //                           ? Colors.green
                      //                           : Colors.grey,
                      //                       width: 2.w)),
                      //               child: Padding(
                      //                 padding: EdgeInsets.all(4.w),
                      //                 child: Center(
                      //                   child: Text(
                      //                     widget.productDetails.variations![index]
                      //                         .clothType ??
                      //                         '',
                      //                     style: TextStyle(fontSize: 13.sp),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       }),
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: EdgeMargin.min, right: EdgeMargin.min),
                        child: NormalOjosTextFieldWidget(
                          controller: noteEditingController,
                          maxLines: 1,
                          filled: true,
                          style: textStyle.smallTSBasic.copyWith(
                              color: globalColor.black,
                              fontWeight: FontWeight.bold),
                          contentPadding: const EdgeInsets.fromLTRB(
                            EdgeMargin.small,
                            EdgeMargin.middle,
                            EdgeMargin.small,
                            EdgeMargin.small,
                          ),
                          fillColor: globalColor.white,
                          backgroundColor: globalColor.white,
                          labelBackgroundColor: globalColor.white,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return Translations.of(
                                  context)
                                  .translate(
                                  'Please enter some text');
                            }
                            return null;
                          },
                          hintText: Translations.of(context)
                              .translate('write_your_notes'),
                          label:
                              Translations.of(context).translate('add_notes'),
                          keyboardType: TextInputType.text,
                          borderRadius: width * .02,
                          onChanged: (value) {
                            setState(() {
                              _noteValidation = true;
                              _note = value;
                            });
                          },
                          borderColor: globalColor.grey.withOpacity(0.3),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                _divider(),
                _buildAddToCartAndFavoriteOfferWidget(
                    context: context,
                    width: width,
                    height: height,
                    productEntity: widget.product,
                    isAuth: isAuth!),
                _divider(),
                _buildSimilarProducts(
                    context: context, width: width, height: height),
                VerticalPadding(
                  percentage: 2.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTopWidget(
      {required BuildContext context,
      required double width,
      required double height,
      required String discountType,
      required var discountPrice,
      required ProductDetailsEntity product}) {
    return Container(
      width: width,
      height: 236.h,
      padding: const EdgeInsets.fromLTRB(EdgeMargin.sub, EdgeMargin.verySub,
          EdgeMargin.sub, EdgeMargin.verySub),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: width,
                  height: 236.h,
                  child: ImageCacheWidget(
                    imageUrl: product.image,
                    imageWidth: width,
                    imageHeight: 236.h,
                    boxFit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  left: 4.0,
                  child: InkWell(
                    onTap: () async {
                      final result = await AddOrRemoveFavorite(
                          locator<ProductRepository>())(
                        AddOrRemoveFavoriteParams(
                            cancelToken: widget.cancelToken,
                            productId: widget.product.id),
                      );
                      if (result.hasDataOnly) {
                        if (mounted)
                          setState(() {
                            // isRemoveFromFavorite = true;
                            //
                            // BlocProvider.of<ApplicationBloc>(context)
                            //     .state
                            //     .setRefreshFavoritePath(true);
                            widget.productDetails.isFavorite =
                                !widget.productDetails.isFavorite;
                            // widget.path.setIsFav(!widget.path.isFav);
                          });
                      } else if (result.hasErrorOnly || result.hasDataAndError)
                        Fluttertoast.showToast(
                            msg: Translations.of(context)
                                .translate('something_went_wrong_try_again'));
                    },
                    child: SvgPicture.asset(
                      widget.productDetails.isFavorite
                          ? AppAssets.love_fill
                          : AppAssets.love,
                      //color: globalColor.black,
                      width: 35.w,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  left: 4.0,
                  child: discountType != null && discountPrice != 0
                      ? Container(
                          decoration: BoxDecoration(
                              color: globalColor.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.w)),
                              border: Border.all(
                                  color: globalColor.grey.withOpacity(0.3),
                                  width: 0.5)),
                          padding: const EdgeInsets.fromLTRB(
                              EdgeMargin.subSubMin,
                              EdgeMargin.verySub,
                              EdgeMargin.subSubMin,
                              EdgeMargin.verySub),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  ' ${Translations.of(context).translate('discount')}',
                                  style: textStyle.minTSBasic
                                      .copyWith(color: globalColor.black)),
                              Text(
                                '  ${discountPrice.toString()} %',
                                style: textStyle.smallTSBasic.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: globalColor.primaryColor),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildTitleAndPriceWidget({
    required BuildContext context,
    required double width,
    required double height,
    required int price,
    required var priceAfterDiscount,
    required var discountPrice,
    required String discountType,
    required String name,
  }) {
    return Container(
      width: width,
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                VerticalPadding(
                  percentage: 1.5,
                ),
                Container(
                  child: Text(
                    '${name ?? ''}' ?? '',
                    style: textStyle.middleTSBasic.copyWith(
                      color: globalColor.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  alignment: AlignmentDirectional.centerStart,
                ),
              ],
            ),
          ),
          Container(
              //  alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.fromLTRB(EdgeMargin.verySub,
                  EdgeMargin.sub, EdgeMargin.verySub, EdgeMargin.sub),
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                        EdgeMargin.subSubMin,
                        EdgeMargin.verySub,
                        EdgeMargin.subSubMin,
                        EdgeMargin.verySub),
                    child: _buildPriceWidget(
                        discountPrice: discountPrice,
                        price: price,
                        priceAfterDiscount: priceAfterDiscount),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  _onSelectSize(GeneralItemEntity size, bool isSelected) {
    if (isSelected) {
      if (mounted) {
        setState(() {
          SizeModeId = size.id;
          //  listOfSizeMode.add(size.id);
        });
      }
    } else {
      if (mounted)
        setState(() {
          //  listOfSizeMode.removeWhere((element) => element == size.id);
        });
    }

    // print('listOfSizeMode ${listOfSizeMode.toString()}');
  }

  // _buildSizeItem(
  //     {BuildContext context,
  //     double width,
  //     double height,
  //     bool isAvailable,
  //     String label,
  //     String size,
  //     String image,
  //     double imageSize}) {
  //   double sizeIcon;
  //   if (size == '40-48') {
  //     sizeIcon = 42.w;
  //   } else if (size == '49-54') {
  //     sizeIcon = 55.w;
  //   } else if (size == '55-58') {
  //     sizeIcon = 65.w;
  //   } else if (size == 'above 58') {
  //     sizeIcon = 80.w;
  //   } else {
  //     sizeIcon = 42.w;
  //   }
  //   return Container(
  //     padding:
  //         const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //     width: width,
  //     height: 46.h,
  //     child: Row(
  //       children: [
  //         Expanded(
  //           flex: 7,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: globalColor.white.withOpacity(0.5),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: utils.getLang() == 'ar'
  //                       ? Radius.circular(10.w)
  //                       : Radius.circular(0.0),
  //                   topRight: utils.getLang() == 'ar'
  //                       ? Radius.circular(10.w)
  //                       : Radius.circular(0.0),
  //                   bottomLeft: utils.getLang() == 'ar'
  //                       ? Radius.circular(0.0)
  //                       : Radius.circular(10.w),
  //                   topLeft: utils.getLang() == 'ar'
  //                       ? Radius.circular(0.0)
  //                       : Radius.circular(10.w)),
  //               border: Border.all(
  //                   color: globalColor.grey.withOpacity(0.3), width: 0.5),
  //             ),
  //             height: 46.h,
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 HorizontalPadding(
  //                   percentage: 1.0,
  //                 ),
  //                 Container(
  //                   width: 25.w,
  //                   height: 25.w,
  //                   decoration: BoxDecoration(
  //                       color: isAvailable
  //                           ? globalColor.primaryColor
  //                           : globalColor.white,
  //                       shape: BoxShape.circle,
  //                       border: Border.all(
  //                           width: 0.5,
  //                           color: isAvailable
  //                               ? globalColor.primaryColor.withOpacity(0.3)
  //                               : globalColor.grey.withOpacity(0.3))),
  //                   child: Center(
  //                     child: CircleAvatar(
  //                       child: isAvailable
  //                           ? Icon(
  //                               MaterialIcons.check,
  //                               color: globalColor.black,
  //                               size: 12,
  //                             )
  //                           : Container(),
  //                       radius: isAvailable ? 15.w : 9.w,
  //                       backgroundColor: isAvailable
  //                           ? globalColor.goldColor
  //                           : globalColor.grey.withOpacity(0.3),
  //                     ),
  //                   ),
  //                 ),
  //                 HorizontalPadding(
  //                   percentage: 1.0,
  //                 ),
  //                 Container(
  //                   child: Text(
  //                     label ?? '',
  //                     style: textStyle.smallTSBasic.copyWith(
  //                         color: globalColor.black,
  //                         fontWeight: FontWeight.w500),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 6,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: globalColor.white.withOpacity(0.5),
  //               border: Border(
  //                 top: BorderSide(
  //                     color: globalColor.grey.withOpacity(0.3), width: 0.5),
  //                 bottom: BorderSide(
  //                     color: globalColor.grey.withOpacity(0.3), width: 0.5),
  //               ),
  //             ),
  //             height: 46.h,
  //             alignment: AlignmentDirectional.center,
  //             //color: globalColor.white,
  //             child: Text(
  //               size ?? '',
  //               style: textStyle.middleTSBasic.copyWith(
  //                   color: globalColor.grey.withOpacity(0.8),
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 6,
  //           child: Container(
  //             alignment: AlignmentDirectional.center,
  //             decoration: BoxDecoration(
  //               color: globalColor.grey.withOpacity(0.1),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: utils.getLang() == 'ar'
  //                       ? Radius.circular(0.0)
  //                       : Radius.circular(10.w),
  //                   topRight: utils.getLang() == 'ar'
  //                       ? Radius.circular(0.0)
  //                       : Radius.circular(10.w),
  //                   bottomLeft: utils.getLang() == 'ar'
  //                       ? Radius.circular(10.w)
  //                       : Radius.circular(0.0),
  //                   topLeft: utils.getLang() == 'ar'
  //                       ? Radius.circular(10.w)
  //                       : Radius.circular(0.0)),
  //               border: Border.all(
  //                   color: globalColor.grey.withOpacity(0.3), width: 0.5),
  //             ),
  //             height: 46.h,
  //             child: SvgPicture.asset(
  //               image ?? '',
  //               width: sizeIcon ?? 10.w,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // _buildAvailableGlassesColors(
  //     {BuildContext context,
  //     double width,
  //     double height,
  //     List<GeneralItemEntity> list}) {
  //   if (list != null && list.isNotEmpty) {
  //     Wrap body = Wrap(
  //         // alignment: WrapAlignment.start,
  //         // runAlignment: WrapAlignment.start,
  //         crossAxisAlignment: WrapCrossAlignment.center,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.fromLTRB(
  //                 EdgeMargin.sub, 0.0, EdgeMargin.sub, 0.0),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   child: Text(
  //                     Translations.of(context).translate('available_colors') ??
  //                         '',
  //                     style: textStyle.middleTSBasic.copyWith(
  //                       color: globalColor.black,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ]);
  //
  //     body.children.addAll(list.map((item) {
  //       return ItemColorProductDetails(
  //         onSelect: _onSelectColors,
  //         item: item,
  //         isSelected: color?.id == item.id,
  //       );
  //     }));
  //     return Container(
  //         width: width,
  //         padding: const EdgeInsets.fromLTRB(
  //             EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //         child: body);
  //   }
  //
  //   return Container();
  // }

  _onSelectColors(GeneralItemEntity colors, bool isSelected) {
    if (isSelected) {
      if (mounted) {
        setState(() {
          color = colors;
          // listOfColorSelected.add(colors.id);
        });
      }
    } else {
      if (mounted)
        setState(() {
          // listOfColorSelected.removeWhere((element) => element == colors.id);
        });
    }

    //  print('listOfYourSelected ${listOfColorSelected.toString()}');
  }

  /* _buildAddToCartAndFavoriteWidget(
      {required BuildContext context,
      required double width,
      required double height,
      required ProductEntity productEntity,
      required bool isAuth}) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<CartProvider>(
            builder: (context, quizProvider, child) {
              return Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () async {
                    if (await UserRepository.hasToken && isAuth) {
                      // if((color!=null&&color.id!=null) && SizeModeId!=null ){
                      //
                      //
                      // }else{
                      //   appConfig.showToast(msg:Translations.of(context).translate('you_must_choose_size_and_color'));
                      // }

                      quizProvider.addItemToCart(CartEntity(
                          id: productEntity.id!,
                          productEntity: productEntity,
                          // isGlasses: productEntity.isGlasses,
                          // colorId: color?.id,
                          // lensSize: null,
                          // sizeForLeftEye: null,
                          // SizeModeId: SizeModeId,
                          // sizeForRightEye: null,
                          // argsForGlasses: selectLensesArgs,
                          count: 1));
                      print('${quizProvider.getItems()!.length}');
                      showDialog(
                        context: context,
                        builder: (ctx) => AddToCartDialog(),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => LoginFirstDialog(),
                      );
                    }

                    // quizProvider.addItemToCart(CartEntity(
                    //     id: productEntity.id,
                    //     productEntity: productEntity,
                    //     isGlasses: productEntity.isGlasses,
                    //     addSize: null,
                    //     ipdSize: null,
                    //     sizeForLeftEye: null,
                    //     sizeForRightEye: null,
                    //     count: 1));
                    // print('${quizProvider.getItems().length}');
                    // showDialog(
                    //   context: context,
                    //   builder: (ctx) => AddToCartDialog(),
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: globalColor.primaryColor,
                      borderRadius: BorderRadius.circular(16.0.w),
                      // border: Border.all(
                      //     width: 0.5,
                      //     color: globalColor.grey.withOpacity(0.3))
                    ),
                    height: 40.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Translations.of(context).translate('add_to_cart'),
                            style: textStyle.smallTSBasic.copyWith(
                                fontWeight: FontWeight.w500,
                                color: globalColor.white),
                          ),
                        ),
                        SvgPicture.asset(
                          AppAssets.cart_nav_bar,
                          color: globalColor.white,
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
*/
  _buildAddToCartAndFavoriteOfferWidget(
      {required BuildContext context,
      required double width,
      required double height,
      required OffersAndDiscount productEntity,
      required bool isAuth}) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: widget.productDetails.type == 'جاهز' ? true : false,
            child: Consumer<CartProvider>(
              builder: (context, quizProvider, child) {
                return Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () async {
                      if (await UserRepository.hasToken && isAuth) {
                        if (_note.isNotEmpty && _length.isNotEmpty && type!=null && selectedColor!=null && size!=null) {
                          quizProvider.addItemToCart(CartEntity(
                              id: productEntity.id,
                              productEntity: ProductEntity(
                                  discount_type: '',
                                  name: productEntity.name,
                                  image: productEntity.image,
                                  rate: '',
                                  review_count: 0,
                                  note: _note,
                                  isReview: true,
                                  isFavorite: false,
                                  product_as_same: [],
                                  quantity: null,
                                  price: (productEntity.price -
                                          productEntity.discount_price)
                                      .abs()
                                      .toInt(),
                                  discount_price: productEntity.discount_price,
                                  category_id: productEntity.category_id,
                                  is_new: null,
                                  description: '',
                                  id: productEntity.id,
                                  length_id: _length,
                                  fabric_id: type,
                                  color_id: selectedColor,
                                  size_id: size),
                              // isGlasses: productEntity.isGlasses,
                              // colorId: color?.id,
                              // lensSize: null,
                              // sizeForLeftEye: null,
                              // SizeModeId: SizeModeId,
                              // sizeForRightEye: null,
                              // argsForGlasses: selectLensesArgs,
                              count: 1));
                          print('${quizProvider.getItems()!.length}');
                          showDialog(
                            context: context,
                            builder: (ctx) => AddToCartDialog(
                              // arguments: CartPageGahezArgs(
                              //     length: length,
                              //     notes: '',
                              //     color: selectedColor,
                              //     size: size,
                              //     type: type),
                              parameters: {"type": "gahez"},
                            ),
                          );
                        }else{
                          Fluttertoast.showToast(
                              msg: "يرجي استكمال البيانات",
                              toastLength:
                              Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.sp);
                        }

                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => LoginFirstDialog(),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: globalColor.primaryColor,
                        borderRadius: BorderRadius.circular(16.0.w),
                        // border: Border.all(
                        //     width: 0.5,
                        //     color: globalColor.grey.withOpacity(0.3))
                      ),
                      height: 40.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Translations.of(context).translate('add_to_cart'),
                              style: textStyle.smallTSBasic.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: globalColor.white),
                            ),
                          ),
                          SvgPicture.asset(
                            AppAssets.cart_nav_bar,
                            color: globalColor.white,
                            width: 20.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Visibility(
            visible: widget.productDetails.type == 'جاهز' ? false : true,
            child: Consumer<CartProvider>(
              builder: (context, quizProvider, child) {
                return Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () async {
                      if (await UserRepository.hasToken && isAuth) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabBarDemo(
                                price: widget.productDetails.price,
                                discountPrice:
                                    widget.productDetails.discount_price,
                                name: widget.productDetails.name,
                                image: widget.productDetails.image,
                              ),
                            ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => LoginFirstDialog(),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: globalColor.primaryColor,
                        borderRadius: BorderRadius.circular(16.0.w),
                        // border: Border.all(
                        //     width: 0.5,
                        //     color: globalColor.grey.withOpacity(0.3))
                      ),
                      height: 40.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Translations.of(context).translate('making'),
                              style: textStyle.smallTSBasic.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: globalColor.white),
                            ),
                          ),
                          // SvgPicture.asset(
                          //   AppAssets.cart_nav_bar,
                          //   color: globalColor.white,
                          //   width: 20.w,
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSimilarProducts(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      child: widget.productDetails.product_as_same != null &&
              widget.productDetails.product_as_same.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.small, right: EdgeMargin.small),
                  child: TitleWithViewAllWidget(
                    width: width,
                    title:
                        Translations.of(context).translate('similar_products'),
                    onClickView: () {},
                    strViewAll: Translations.of(context).translate('view_all'),
                  ),
                ),
                Container(
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.productDetails.product_as_same.length,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          childAspectRatio:
                              globalSize.setWidthPercentage(47, context) /
                                  globalSize.setWidthPercentage(60, context),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return ItemProductHomeWidget(
                            fromHome: true,
                            height: globalSize.setWidthPercentage(60, context),
                            width: globalSize.setWidthPercentage(47, context),
                            product:
                                widget.productDetails.product_as_same[index],
                          );
                        }))
              ],
            )
          : Container(),
    );
  }

  _divider() {
    return Divider(
      color: globalColor.grey.withOpacity(0.3),
      height: 8.h,
    );
  }

  _buildPriceWidget(
      {required int price,
      required var discountPrice,
      required var priceAfterDiscount}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          discountPrice != null && discountPrice != 0.0
              ? Container(
                  child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: '${price.toString() ?? ''}',
                      style: textStyle.middleTSBasic.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                          color: globalColor.grey),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                ' ${Translations.of(context).translate('rail')}',
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.grey)),
                      ],
                    ),
                  ),
                ))
              : Container(
                  child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: price.toString() ?? '',
                      style: textStyle.middleTSBasic.copyWith(
                          fontWeight: FontWeight.bold,
                          color: globalColor.primaryColor),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                ' ${Translations.of(context).translate('rail')}',
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.black)),
                      ],
                    ),
                  ),
                )),
          HorizontalPadding(percentage: 2.5),
          discountPrice != null && discountPrice != 0.0
              ? Container(
                  child: FittedBox(
                  child: RichText(
                    text: TextSpan(
                      text: (price - priceAfterDiscount).abs().toString(),
                      style: textStyle.middleTSBasic.copyWith(
                          fontWeight: FontWeight.bold,
                          color: globalColor.primaryColor),
                      children: <TextSpan>[
                        new TextSpan(
                            text:
                                ' ${Translations.of(context).translate('rail')}',
                            style: textStyle.smallTSBasic
                                .copyWith(color: globalColor.black)),
                      ],
                    ),
                  ),
                ))
              : Container(),
        ],
      ),
    );
  }
}

String? vRequired(context, value) {
  if (value != null) {
    return null;
  } else {
    return Translations.of(context).translate('v_required');
  }
}

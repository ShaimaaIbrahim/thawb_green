import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/items_shimmer/base_shimmer.dart';
import 'package:ojos_app/core/ui/items_shimmer/item_general_shimmer.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/core/ui/widget/text/normal_form_field.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/product/domin/entities/image_info_entity.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsShimmer extends StatefulWidget {
  final double width;
  final double height;
  final OffersAndDiscount product;

  const ProductDetailsShimmer({
    required this.height,
    required this.width,
    required this.product,
  });

  @override
  _ProductDetailsShimmerState createState() => _ProductDetailsShimmerState();
}

class _ProductDetailsShimmerState extends State<ProductDetailsShimmer> {
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

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? globalSize.setWidthPercentage(100, context);
    final height =
        widget.height ?? globalSize.setHeightPercentage(100, context);
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                  discountPrice: widget.product.discount_price.toDouble(),
                  discountType: 0,
                  product: widget.product),

              _buildTitleAndPriceWidget(
                context: context,
                width: width,
                height: height,
                price: widget.product.price,
                priceAfterDiscount: widget.product.discount_price.toString(),
                discountPrice: widget.product.discount_price,
                discountType: widget.product.price.toString(),
                name: widget.product.name,
              ),

              // _divider(),
              //
              // _buildAvailableSizeWidget(
              //     context: context, width: width, height: height),
              // _divider(),
              // _buildAvailableGlassesColors(
              //     context: context,
              //     width: width,
              //     height: height,
              //     list: [
              //       Colors.red,
              //       Colors.grey.shade100,
              //       Colors.pinkAccent,
              //       Colors.black,
              //       Colors.orange,
              //       Colors.blue,
              //       Colors.amber
              //     ]),

              // _divider(),
              //
              // _buildEnterDimensionsOfGlassesWidget(
              //     context: context, width: width, height: height),

              // VerticalPadding(
              //   percentage: 2.0,
              // ),
              //
              // _buildTryChooseWidget(
              //     context: context, width: width, height: height),

              VerticalPadding(
                percentage: 2.0,
              ),

              // _buildGuaranteedRefundWidget(
              //     context: context, width: width, height: height),

              _divider(),

              _buildAddToCartAndFavoriteWidget(
                  context: context, width: width, height: height),

              _divider(),

              _buildSimilarProducts(
                  context: context, width: width, height: height),

              VerticalPadding(
                percentage: 2.5,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTopWidget(
      {required BuildContext context,
      required double width,
      required double height,
      required int discountType,
      required double discountPrice,
      required OffersAndDiscount product}) {
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
                Stack(
                  children: [
                    Container(
                      width: width,
                      height: 236.h,
                      child: ImageCacheWidget(
                        imageUrl: product.image ?? '',
                        imageWidth: width,
                        imageHeight: 236.h,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 4.0,
                  bottom: 4.0,
                  child: SvgPicture.asset(
                    AppAssets.love,
                    color: globalColor.black,
                    width: 40.w,
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  left: 4.0,
                  child: discountType != null
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
                          child: discountType == 1
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${discountPrice ?? '-'} ${Translations.of(context).translate('rail')}' ??
                                          '',
                                      style: textStyle.smallTSBasic.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: globalColor.primaryColor),
                                    ),
                                    Text(
                                        ' ${Translations.of(context).translate('discount')}',
                                        style: textStyle.minTSBasic.copyWith(
                                            color: globalColor.black)),
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${discountPrice ?? '-'} %' ?? '',
                                      style: textStyle.smallTSBasic.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: globalColor.primaryColor),
                                    ),
                                    Text(
                                        ' ${Translations.of(context).translate('discount')}',
                                        style: textStyle.minTSBasic.copyWith(
                                            color: globalColor.black)),
                                  ],
                                ),
                        )
                      : Container(),
                ),
              ],
            ),
            // product.photoInfo != null && product.photoInfo.isNotEmpty
            //     ? Positioned(
            //     bottom: 10,
            //     child: _buildPageIndicator2(
            //         width: width, list: product.photoInfo))
          ],
        ),
      ),
    );
  }
  //
  // _buildPageIndicator2({double width, List<ImageInfoEntity> list}) {
  //   return Container(
  //     alignment: AlignmentDirectional.center,
  //     width: width,
  //     child: SmoothPageIndicator(
  //         controller: controller, //// PageController
  //         count: list.length,
  //         effect: WormEffect(
  //           spacing: 4.0,
  //           radius: 10.0,
  //           dotWidth: 10.0,
  //           dotHeight: 10.0,
  //           dotColor: Colors.white,
  //           paintStyle: PaintingStyle.fill,
  //           strokeWidth: 2,
  //           activeDotColor: globalColor.primaryColor,
  //         ), // your preferred effect
  //         onDotClicked: (index) {}),
  //   );
  // }

  _buildTitleAndPriceWidget({
    required BuildContext context,
    required double width,
    required double height,
    required int price,
    required String priceAfterDiscount,
    required int discountPrice,
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
                // Container(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       isFree != null && isFree
                //           ? Container(
                //               width: 15.w,
                //               height: 15.w,
                //               decoration: BoxDecoration(
                //                   color: globalColor.goldColor,
                //                   shape: BoxShape.circle,
                //                   border: Border.all(
                //                       width: 1.0,
                //                       color: globalColor.primaryColor)),
                //               child: Icon(
                //                 MaterialIcons.check,
                //                 color: globalColor.black,
                //                 size: 10.w,
                //               ),
                //             )
                //           : Container(
                //               width: 15.w,
                //               height: 15.w,
                //               decoration: BoxDecoration(
                //                   color: globalColor.grey,
                //                   shape: BoxShape.circle,
                //                   border: Border.all(
                //                       width: 1.0,
                //                       color: globalColor.grey
                //                           .withOpacity(0.3))),
                //               child: Center(
                //                 child: Text(''),
                //               ),
                //             ),
                //       Container(
                //           padding: const EdgeInsets.only(
                //               left: EdgeMargin.sub, right: EdgeMargin.sub),
                //           child: Text(
                //             '${Translations.of(context).translate('free_lenses')}' ??
                //                 '',
                //             style: textStyle.minTSBasic.copyWith(
                //                 fontWeight: FontWeight.w500,
                //                 color: globalColor.grey),
                //           ))
                //     ],
                //   ),
                // ),
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

  _buildPriceWidget(
      {required int price,
      required int discountPrice,
      required String priceAfterDiscount}) {
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
                      text: (price-discountPrice).abs().toString(),
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
  /* _buildTitleAndPriceWidget({
    required BuildContext context,
    required double width,
    required double height,
    required double price,
    required String priceAfterDiscount,
    required double discountPrice,
    required int discountType,
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
                // Container(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       isFree != null && isFree
                //           ? Container(
                //               width: 15.w,
                //               height: 15.w,
                //               decoration: BoxDecoration(
                //                   color: globalColor.goldColor,
                //                   shape: BoxShape.circle,
                //                   border: Border.all(
                //                       width: 1.0,
                //                       color: globalColor.primaryColor)),
                //               child: Icon(
                //                 MaterialIcons.check,
                //                 color: globalColor.black,
                //                 size: 10.w,
                //               ),
                //             )
                //           : Container(
                //               width: 15.w,
                //               height: 15.w,
                //               decoration: BoxDecoration(
                //                   color: globalColor.grey,
                //                   shape: BoxShape.circle,
                //                   border: Border.all(
                //                       width: 1.0,
                //                       color: globalColor.grey
                //                           .withOpacity(0.3))),
                //               child: Center(
                //                 child: Text(''),
                //               ),
                //             ),
                //       Container(
                //           padding: const EdgeInsets.only(
                //               left: EdgeMargin.sub, right: EdgeMargin.sub),
                //           child: Text(
                //             '${Translations.of(context).translate('free_lenses')}' ??
                //                 '',
                //             style: textStyle.minTSBasic.copyWith(
                //                 fontWeight: FontWeight.w500,
                //                 color: globalColor.grey),
                //           ))
                //     ],
                //   ),
                // ),
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
                    // decoration: BoxDecoration(
                    //     color: globalColor.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(12.w)),
                    //     border: Border.all(
                    //         color: globalColor.grey.withOpacity(0.3),
                    //         width: 0.5)),
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
              ))
        ],
      ),
    );
  }*/
  //
  // _buildAvailableSizeWidget(
  //     {BuildContext context, double width, double height}) {
  //   return Container(
  //     width: width,
  //     padding:
  //     const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.fromLTRB(
  //               EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                 flex: 1,
  //                 child: Container(
  //                   child: Text(
  //                     Translations.of(context).translate('available_sizes') ??
  //                         '',
  //                     style: textStyle.middleTSBasic.copyWith(
  //                       color: globalColor.black,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: globalColor.grey.withOpacity(0.5)),
  //                 child: Center(
  //                   child: Icon(
  //                     MaterialIcons.keyboard_arrow_down,
  //                     color: globalColor.black,
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         VerticalPadding(
  //           percentage: 2.0,
  //         ),
  //         Container(
  //           padding:
  //           const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //           child: Column(
  //             children: [
  //
  //               BaseShimmerWidget(
  //
  //                 child: Container(
  //                   width: width,
  //                   height: 46.h,
  //                   color: Colors.white,
  //
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // _buildAvailableGlassesColors(
  //     {BuildContext context, double width, double height, List<Color> list}) {
  //   Wrap body = Wrap(
  //     // alignment: WrapAlignment.start,
  //     // runAlignment: WrapAlignment.start,
  //       crossAxisAlignment: WrapCrossAlignment.center,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.fromLTRB(
  //               EdgeMargin.sub, 0.0, EdgeMargin.sub, 0.0),
  //           child: Row(
  //             children: [
  //               Container(
  //                 child: Text(
  //                   Translations.of(context).translate('available_colors') ??
  //                       '',
  //                   style: textStyle.middleTSBasic.copyWith(
  //                     color: globalColor.black,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                   maxLines: 1,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ]);
  //
  //   body.children.addAll(list.map((item) {
  //     return Container(
  //       decoration: BoxDecoration(
  //         color: globalColor.white.withOpacity(0.5),
  //         borderRadius: BorderRadius.all(Radius.circular(10.w)),
  //         border:
  //         Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
  //       ),
  //       height: 35.h,
  //       width: 65.w,
  //       margin: const EdgeInsets.only(
  //           left: EdgeMargin.verySub,
  //           right: EdgeMargin.verySub,
  //           bottom: EdgeMargin.verySub),
  //       child: BaseShimmerWidget(
  //
  //         child: Container(
  //           width: width,
  //           height: 46.h,
  //           color: Colors.white,
  //
  //         ),
  //       ),
  //     );
  //   }));
  //   return Container(
  //       width: width,
  //       padding:
  //       const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //       child: body);
  // }
  //
  // _buildEnterDimensionsOfGlassesWidget(
  //     {BuildContext context, double width, double height}) {
  //   return Container(
  //     width: width,
  //     padding:
  //     const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.fromLTRB(
  //               EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                 flex: 1,
  //                 child: Container(
  //                   child: Text(
  //                     Translations.of(context).translate(
  //                         'enter_the_dimensions_of_the_glasses') ??
  //                         '',
  //                     style: textStyle.middleTSBasic.copyWith(
  //                       color: globalColor.black,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                   ),
  //                 ),
  //               ),
  //               // Container(
  //               //   decoration: BoxDecoration(
  //               //       shape: BoxShape.circle,
  //               //       color: globalColor.grey.withOpacity(0.5)),
  //               //   child: Center(
  //               //     child: Icon(
  //               //       MaterialIcons.keyboard_arrow_down,
  //               //       color: globalColor.black,
  //               //     ),
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           child: Row(
  //             children: [
  //               Expanded(
  //                   flex: 1,
  //                   child: _buildDimensionsInputWidget(
  //                     context: context,
  //                     controller: frameHeightEditingController,
  //                     height: height,
  //                     width: width,
  //                     text: _frameHeight,
  //                     textValidation: _frameHeightValidation,
  //                     image: AppAssets.frame_height_png,
  //                     imageSize: 65.w,
  //                     widgetSubTitle: 'Frame Height',
  //                     widgetTitle: 'ارتفاع الاطار',
  //                   )),
  //               HorizontalPadding(
  //                 percentage: 0.5,
  //               ),
  //               Expanded(
  //                   flex: 1,
  //                   child: _buildDimensionsInputWidget(
  //                     context: context,
  //                     controller: frameWidthEditingController,
  //                     height: height,
  //                     width: width,
  //                     text: _frameWidth,
  //                     textValidation: _frameWidthValidation,
  //                     image: AppAssets.frame_width_png,
  //                     imageSize: 65.w,
  //                     widgetSubTitle: 'Frame Width',
  //                     widgetTitle: 'عرض الاطار',
  //                   )),
  //               HorizontalPadding(
  //                 percentage: 0.5,
  //               ),
  //               Expanded(
  //                   flex: 1,
  //                   child: _buildDimensionsInputWidget(
  //                     context: context,
  //                     controller: frameLengthEditingController,
  //                     height: height,
  //                     width: width,
  //                     text: _frameLength,
  //                     textValidation: _frameLengthValidation,
  //                     image: AppAssets.frame_length_png,
  //                     imageSize: 65.w,
  //                     widgetSubTitle: 'Frame Length',
  //                     widgetTitle: 'طول الاطار',
  //                   )),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

/*
  _buildDimensionsInputWidget({
    BuildContext context,
    double width,
    double height,
    TextEditingController controller,
    bool textValidation,
    String text,
    String widgetTitle,
    String image,
    double imageSize,
    String widgetSubTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
        Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      child: Column(
        children: [
          VerticalPadding(
            percentage: 1.0,
          ),
          Container(
            child: Text(
              widgetTitle,
              style: textStyle.minTSBasic.copyWith(color: globalColor.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(EdgeMargin.subSubMin),
            child: Container(
              decoration: BoxDecoration(
                color: globalColor.white.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(12.w)),
                border: Border.all(
                    color: globalColor.grey.withOpacity(0.3), width: 0.5),
              ),
              padding: const EdgeInsets.all(EdgeMargin.sub),
              child: Center(
                child: Column(
                  children: [
                    VerticalPadding(
                      percentage: 1.0,
                    ),
                    Container(
                      child: Image.asset(
                        image ?? AppAssets.frame_height_png,
                        width: imageSize ?? 55.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    VerticalPadding(
                      percentage: 2.0,
                    ),
                    Container(
                      child: Text(
                        widgetSubTitle ?? '',
                        style: textStyle.sub2MinTSBasic
                            .copyWith(color: globalColor.black),
                      ),
                    ),
                    VerticalPadding(
                      percentage: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(EdgeMargin.subSubMin),
            child: Container(
              child: BorderFormField(
                controller: controller,
                validator: (value) {
                  return BaseValidator.validateValue(
                    context,
                    value,
                    [],
                    textValidation,
                  );
                },
                hintText: '48mm',
                hintStyle: textStyle.minTSBasic.copyWith(
                    color: globalColor.grey, fontWeight: FontWeight.bold),
                style: textStyle.minTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
                filled: false,
                keyboardType: TextInputType.number,
                borderRadius: 12.w,
                onChanged: (value) {
                  setState(() {
                    textValidation = true;
                    text = value;
                  });
                },
                textAlign: TextAlign.center,
                borderColor: globalColor.grey.withOpacity(0.3),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
*/

  _buildAddToCartAndFavoriteWidget(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded(
          //   flex: 3,
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: globalColor.white,
          //         borderRadius: BorderRadius.circular(16.0.w),
          //         border: Border.all(
          //             width: 0.5, color: globalColor.grey.withOpacity(0.3))),
          //     height: 35.w,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         SvgPicture.asset(
          //           AppAssets.love,
          //           color: globalColor.black,
          //           width: 20.w,
          //         ),
          //         Text(
          //           Translations.of(context).translate('favorite'),
          //           style: textStyle.smallTSBasic.copyWith(
          //               fontWeight: FontWeight.w500,
          //               color: globalColor.primaryColor),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // HorizontalPadding(
          //   percentage: 2.0,
          // ),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  color: globalColor.primaryColor,
                  borderRadius: BorderRadius.circular(16.0.w),
                  border: Border.all(
                      width: 0.5, color: globalColor.grey.withOpacity(0.3))),
              height: 35.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Translations.of(context).translate('add_to_cart'),
                    style: textStyle.smallTSBasic.copyWith(
                        fontWeight: FontWeight.w500, color: globalColor.white),
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
        ],
      ),
    );
  }

  _buildSimilarProducts(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              title: Translations.of(context).translate('similar_products'),
              onClickView: () {},
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
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
                    return ItemGeneralShimmer(
                      height: globalSize.setWidthPercentage(60, context),
                      width: globalSize.setWidthPercentage(47, context),
                    );
                  }))
        ],
      ),
    );
  }

  _divider() {
    return Divider(
      color: globalColor.grey.withOpacity(0.3),
      height: 20.h,
    );
  }
}

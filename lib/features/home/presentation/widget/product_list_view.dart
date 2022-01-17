import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_size.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProductItemWidget extends StatefulWidget {
  final OffersAndDiscount product;
  final double? width;
  final double? height;

  // final double height;
  const CustomProductItemWidget(
      {required this.product, required this.width, required this.height});

  @override
  _CustomProductItemWidgetState createState() =>
      _CustomProductItemWidgetState();
}

class _CustomProductItemWidgetState extends State<CustomProductItemWidget> {
  @override
  Widget build(BuildContext context) {
    double width = widget.width ?? globalSize.setWidthPercentage(43, context);
    double height =
        widget.height ?? globalSize.setHeightPercentage(60, context);

    int Price = 0;
    if (widget.product.discount_price == null) {
      Price = widget.product.price;
    } else {
      Price =
          (widget.product.price - widget.product.discount_price! as int).abs();
    }

    return Container(
      // width: width,
      height: height,
      // color: globalColor.red,
      padding: EdgeInsets.only(
          left: utils.getLang() == 'ar' ? 0.0 : EdgeMargin.verySub,
          right: utils.getLang() == 'ar' ? EdgeMargin.verySub : 0.0),
      child: InkWell(
        onTap: () {
          print('click');
          Get.Get.toNamed(ProductDetailsPage.routeName,
              preventDuplicates: false,
              arguments: ProductDetailsArguments1(product: widget.product));
          // else
          //   Get.Get.toNamed(LensesDetailsPage.routeName,preventDuplicates: false,arguments: ProductDetailsArguments(product: widget.product));
        },
        child: Card(
          elevation: 6,
          shadowColor: Colors.grey.shade100,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0.w))),
          child: Container(
              decoration: BoxDecoration(
                color: globalColor.white,
                borderRadius: BorderRadius.circular(12.0.w),
              ),
              //   padding: const EdgeInsets.all(1.0),
              width: width,
              height: height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(EdgeMargin.verySub),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0.w)),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ImageCacheWidget(
                                    imageUrl: widget.product.image,
                                    boxFit: BoxFit.fill,
                                    imageHeight: 100,
                                    imageWidth: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(EdgeMargin.sub),
                            child: FittedBox(
                              child: Row(
                                children: [
                                  Container(
                                    width: width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle(
                                                fontSize: textSize.middle),
                                            maxLines: 2,
                                            text: TextSpan(
                                                style: textStyle.middleTSBasic
                                                    .copyWith(
                                                  color: globalColor.black,
                                                ),
                                                text: widget.product.name),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle: StrutStyle(
                                                fontSize: textSize.middle),
                                            maxLines: 2,
                                            text: TextSpan(
                                                style: textStyle.middleTSBasic
                                                    .copyWith(
                                                  color: globalColor.black,
                                                ),
                                                text: Price.toString() ?? '',
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text: ' ${Translations.of(context).translate('rail')}',
                                                      style: textStyle.subMinTSBasic
                                                          .copyWith(color: globalColor.grey)),
                                                ],
                                            ),
                                          ),
                                        ),
                                        widget.product.discount_price != null &&
                                            widget.product.discount_price !=
                                                0
                                            ? _buildPriceWidget(
                                            width: width,
                                            discountPrice: widget
                                                .product.discount_price
                                                .toInt(),
                                            price: widget.product.price
                                                .toDouble()): Container(),
                                        /*
                                            discountPrice: widget
                                                .product.price_discount
                                                .toString()),*/
                                        VerticalPadding(
                                          percentage: 0.5,
                                        ),

                                        // Container(
                                        //   child: FittedBox(
                                        //     child: Row(
                                        //       crossAxisAlignment:
                                        //           CrossAxisAlignment.center,
                                        //       children: [
                                        //         Container(
                                        //           width: 12.w,
                                        //           height: 12.w,
                                        //           decoration: BoxDecoration(
                                        //               color: globalColor.goldColor,
                                        //               shape: BoxShape.circle,
                                        //               border: Border.all(
                                        //                   width: 1.0,
                                        //                   color: globalColor
                                        //                       .primaryColor)),
                                        //           child: Icon(
                                        //             MaterialIcons.check,
                                        //             color: globalColor.black,
                                        //             size: 10.w,
                                        //           ),
                                        //         ),
                                        //         Container(
                                        //           padding: const EdgeInsets.only(
                                        //               left: EdgeMargin.sub,
                                        //               right: EdgeMargin.sub),
                                        //           child: RichText(
                                        //             text: TextSpan(
                                        //               text: appConfig
                                        //                       .notNullOrEmpty(widget
                                        //                           .product
                                        //                           .colorInfo
                                        //                           ?.length
                                        //                           .toString())
                                        //                   ? widget
                                        //                       .product
                                        //                       .colorInfo
                                        //                       ?.length
                                        //                       .toString()
                                        //                   : '-',
                                        //               style: textStyle.minTSBasic
                                        //                   .copyWith(
                                        //                       fontWeight:
                                        //                           FontWeight.bold,
                                        //                       color: globalColor
                                        //                           .primaryColor),
                                        //               children: <TextSpan>[
                                        //                 new TextSpan(
                                        //                     text:
                                        //                         ' ${Translations.of(context).translate('colors_available')}',
                                        //                     style: textStyle
                                        //                         .minTSBasic
                                        //                         .copyWith(
                                        //                             color:
                                        //                                 globalColor
                                        //                                     .grey)),
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         )
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  // HorizontalPadding(
                                  //   percentage: 1.0,
                                  // ),
                                  // _buildPriceWidget(
                                  //     width: width * 0.35,
                                  //     price: widget.product.price,
                                  //     discountPrice:
                                  //         widget.product.priceAfterDiscount)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     Expanded(
                  //       flex:7,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         children: [
                  //           widget.product.type!=1 ?
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               color: globalColor.white,
                  //               borderRadius: BorderRadius.circular(12.0.w),
                  //             ),
                  //             padding: const EdgeInsets.fromLTRB(EdgeMargin.verySub, EdgeMargin.verySub, EdgeMargin.verySub, EdgeMargin.verySub),
                  //             constraints: BoxConstraints(maxWidth: width*.5),
                  //             child: Text('عدسات طبية',style: textStyle.minTSBasic.copyWith(
                  //               color: globalColor.black
                  //             ),),
                  //           ) : Container(),
                  //         ],
                  //       ),
                  //     ),
                  //     Expanded(flex:6,child: Container(),)
                  //   ],
                  // )
                ],
              )),
        ),
      ),
    );
  }

  _buildPriceWidget(
      {required double? price,
      required int? discountPrice,
      required double width}) {
    return Container(
      width: width,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* discountPrice != null && discountPrice != "0.0"
              ? */
          Container(
              child: RichText(
            text: TextSpan(
              text: price.toString(),
              style: textStyle.smallTSBasic.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                  color: globalColor.grey),
              children: <TextSpan>[
                new TextSpan(
                    text: ' ${Translations.of(context).translate('rail')}',
                    style: textStyle.subMinTSBasic
                        .copyWith(color: globalColor.grey)),
              ],
            ),
          )),
          // : Container(
          //     child: RichText(
          //     text: TextSpan(
          //       text: price == null ? '0.0' : price.toString(),
          //       style: textStyle.smallTSBasic.copyWith(
          //           fontWeight: FontWeight.bold,
          //           color: globalColor.primaryColor),
          //       children: <TextSpan>[
          //         new TextSpan(
          //             text:
          //                 ' ${Translations.of(context).translate('rail')}',
          //             style: textStyle.subMinTSBasic
          //                 .copyWith(color: globalColor.black)),
          //       ],
          //     ),
          //   )),

          SizedBox(
            width: 5.w,
          ),
          // discountPrice != null && discountPrice.isNotEmpty
          //     ?
          Container(
              child: FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' ${Translations.of(context).translate('rail_discount')}',
                    style: textStyle.smallTSBasic
                        .copyWith(color: globalColor.primaryColor)),
                Text(
                  discountPrice == null ? '0' : discountPrice.toString(),
                  style: textStyle.smallTSBasic.copyWith(
                      fontWeight: FontWeight.bold,
                      color: globalColor.primaryColor),
                ),
              ],
            ),
          ))
          // : SizedBox.shrink(),
        ],
      ),
    );
  }
  // _buildPriceWidget(
  //     {required double price,
  //     required int discountPrice,
  //     required double width}) {
  //   return Container(
  //     width: width,
  //     child: Row(
  //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //             child: RichText(
  //           text: TextSpan(
  //             text: '${price.toString()}',
  //             style: textStyle.smallTSBasic.copyWith(
  //                 fontWeight: FontWeight.bold,
  //                 decoration: TextDecoration.lineThrough,
  //                 color: globalColor.grey),
  //             children: <TextSpan>[
  //               new TextSpan(
  //                   text: ' ${Translations.of(context).translate('rail')}',
  //                   style: textStyle.subMinTSBasic
  //                       .copyWith(color: globalColor.grey)),
  //             ],
  //           ),
  //         )),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         Container(
  //             child: FittedBox(
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 "$discountPrice",
  //                 style: textStyle.smallTSBasic.copyWith(
  //                     fontWeight: FontWeight.bold,
  //                     color: globalColor.primaryColor),
  //               ),
  //               Text(' ${Translations.of(context).translate('rail')}',
  //                   style: textStyle.smallTSBasic
  //                       .copyWith(color: globalColor.primaryColor)),
  //             ],
  //           ),
  //         ))
  //         // : SizedBox.shrink(),
  //       ],
  //     ),
  //   );
  // }
}

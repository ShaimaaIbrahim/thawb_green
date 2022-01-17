import 'package:flutter/material.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';

class ItemOfferWidget extends StatelessWidget {
  final Add offerItem;
  final double width;
  const ItemOfferWidget({required this.offerItem, required this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.Get.toNamed(ProductDetailsPage.routeName,
            preventDuplicates: false,
            arguments: ProductDetailsArguments1(
                product: OffersAndDiscount(
              category_id: null,
              image: '',
              price: 0,
              categoryname: '',
              name: offerItem.name,
              id: offerItem.product_id,
              discount_price: offerItem.discount_price,
            )));
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: 200.h,
                  child: ImageCacheWidget(
                    imageUrl: offerItem.image,
                    imageWidth: width,
                    imageHeight: 200.h,
                    boxFit: BoxFit.fill,
                    imageBorderRadius: 0.0,
                  ),
                ),
                // Align(
                //   alignment:
                //   AlignmentDirectional.centerEnd,
                //   child: Diagonal(
                //     clipHeight: 45.0,
                //     axis: Axis.vertical,
                //     position: DiagonalPosition.TOP_RIGHT,
                //     child: Container(
                //       width: width * .3,
                //       height: 184.h,
                //       color: globalColor.primaryColor,
                //       child: Column(
                //         crossAxisAlignment:
                //         CrossAxisAlignment.end,
                //         children: [
                //           Padding(
                //             padding:
                //             const EdgeInsets.only(
                //                 left: 20,
                //                 right: 10,
                //                 top: 5),
                //             child: Text(
                //               Translations.of(context)
                //                   .translate('discount'),
                //               style: textStyle
                //                   .lagerTSBasic
                //                   .copyWith(
                //                   color: globalColor
                //                       .white),
                //             ),
                //           ),
                //           offerItem.discountTypeInt!=null && offerItem.discountTypeInt ==1 ?
                //           Container(
                //             padding:
                //             const EdgeInsets.only(
                //                 left: 20),
                //             child: RichText(
                //               text: TextSpan(
                //                 text: '${offerItem.discountPrice??''}',
                //                 style: textStyle
                //                     .lagerTSBasic
                //                     .copyWith(
                //                     fontWeight:
                //                     FontWeight
                //                         .bold,
                //                     height: .8,
                //                     color: globalColor
                //                         .goldColor),
                //                 children: <TextSpan>[
                //                   new TextSpan(
                //                       text:
                //                       Translations.of(
                //                           context)
                //                           .translate(
                //                           'rail'),
                //                       style: textStyle
                //                           .smallTSBasic
                //                           .copyWith(
                //                           color: globalColor
                //                               .white)),
                //                 ],
                //               ),
                //             ),
                //           )
                //               :
                //           Container(
                //             padding:
                //             const EdgeInsets.only(
                //                 left: 20),
                //             child: RichText(
                //               text: TextSpan(
                //                 text: '%',
                //                 style: textStyle
                //                     .smallTSBasic
                //                     .copyWith(
                //                     color: globalColor
                //                         .white),
                //                 children: <TextSpan>[
                //                   new TextSpan(
                //                       text:'${offerItem.discountPrice??''}',
                //                       style: textStyle
                //                           .lagerTSBasic
                //                           .copyWith(
                //                           fontWeight:
                //                           FontWeight
                //                               .bold,
                //                           height: .8,
                //                           color: globalColor
                //                               .goldColor),)
                //                 ],
                //               ),
                //             ),
                //           )
                //           ,
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

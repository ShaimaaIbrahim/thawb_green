import 'package:flutter/material.dart';
import 'package:ojos_app/core/entities/offer_item_entity.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/features/product/data/models/product_model.dart';
import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
import 'package:ojos_app/features/product/presentation/args/product_details_args.dart';
import 'package:ojos_app/features/product/presentation/pages/lenses_details_page.dart';
import 'package:ojos_app/features/product/presentation/pages/product_details_page.dart';

// class ItemOfferMiddle1Widget extends StatelessWidget {
//   final OfferItemEntity offerItem;
//   final double width;
//   final double height;
//   const ItemOfferMiddle1Widget(
//       {required this.offerItem, required this.width, required this.height});
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         if (offerItem.is_glasses != null && offerItem.is_glasses!)
//           Get.Get.toNamed(ProductDetailsPage.routeName,
//               preventDuplicates: false,
//               arguments: ProductDetailsArguments(
//                   product: ProductEntity(
//                 id: offerItem.productId,
//                 name: offerItem.name,
//                 category_id: 0,
//                 image: '',
//                 is_new: false,
//                 isReview: false,
//                 isFavorite: false,
//                 quantity: 0,
//                 review_count: 0,
//                 discount_price: offerItem.discountPrice,
//                 discount_type: '',
//                 description: '',
//                 price: offerItem.discountPrice,
//                 rate: '',
//                 product_as_same: [],
//               )));
//         else
//           Get.Get.toNamed(LensesDetailsPage.routeName,
//               preventDuplicates: false,
//               arguments: ProductDetailsArguments(
//                   product: ProductEntity(
//                       id: offerItem.productId,
//                       name: offerItem.name,
//                       category_id: 0,
//                       image: '',
//                       is_new: false,
//                       isReview: false,
//                       isFavorite: false,
//                       quantity: 0,
//                       review_count: 0,
//                       discount_price: offerItem.discountPrice,
//                       discount_type: '',
//                       description: '',
//                       price: offerItem.discountPrice,
//                       rate: '',
//                       product_as_same: [])));
//       },
//       child: Container(
//           child: Padding(
//         padding: const EdgeInsets.fromLTRB(EdgeMargin.small, EdgeMargin.verySub,
//             EdgeMargin.small, EdgeMargin.verySub),
//         child: Container(
//           width: width,
//           height: 90.h,
//           child: ClipRRect(
//             borderRadius: BorderRadius.all(Radius.circular(width * .04)),
//             child: Stack(
//               children: [
//                 Container(
//                   width: width,
//                   height: height * .25,
//                   child: ImageCacheWidget(
//                     imageUrl: offerItem.image ?? '',
//                     imageWidth: width,
//                     imageHeight: 90.h,
//                     boxFit: BoxFit.cover,
//                     imageBorderRadius: 0.0,
//                   ),
//                 ),
//                 // Align(
//                 //   alignment: AlignmentDirectional.centerEnd,
//                 //   child: Diagonal(
//                 //     clipHeight: 70.0,
//                 //     axis: Axis.vertical,
//                 //     position: DiagonalPosition.TOP_RIGHT,
//                 //     child: Container(
//                 //       width: 154.86.w,
//                 //       height: height * .25,
//                 //       color: globalColor.primaryColor,
//                 //       child: Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.end,
//                 //         children: [
//                 //           Padding(
//                 //             padding: const EdgeInsets.only(
//                 //                 left: 20, right: 10, top: 5),
//                 //             child: Text(
//                 //               Translations.of(context).translate('discount'),
//                 //               style: textStyle.lagerTSBasic
//                 //                   .copyWith(color: globalColor.white),
//                 //             ),
//                 //           ),
//                 //           offerItem.discountTypeInt!=null && offerItem.discountTypeInt ==1 ?
//                 //           Container(
//                 //             padding: const EdgeInsets.only(left: 20),
//                 //             child: RichText(
//                 //               text: new TextSpan(
//                 //                 text: '99',
//                 //                 style: textStyle.lagerTSBasic.copyWith(
//                 //                     fontWeight: FontWeight.bold,
//                 //                     height: .8,
//                 //                     color: globalColor.goldColor),
//                 //                 children: <TextSpan>[
//                 //                   new TextSpan(
//                 //                       text: Translations.of(context)
//                 //                           .translate('rail'),
//                 //                       style: textStyle.smallTSBasic
//                 //                           .copyWith(color: globalColor.white)),
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           ) :
//                 //           Container(
//                 //             padding:
//                 //             const EdgeInsets.only(
//                 //                 left: 20),
//                 //             child: RichText(
//                 //               text: TextSpan(
//                 //                 text: '%',
//                 //                 style: textStyle
//                 //                     .smallTSBasic
//                 //                     .copyWith(
//                 //                     color: globalColor
//                 //                         .white),
//                 //                 children: <TextSpan>[
//                 //                   new TextSpan(
//                 //                     text:'${offerItem.discountPrice??''}',
//                 //                     style: textStyle
//                 //                         .lagerTSBasic
//                 //                         .copyWith(
//                 //                         fontWeight:
//                 //                         FontWeight
//                 //                             .bold,
//                 //                         height: .8,
//                 //                         color: globalColor
//                 //                             .goldColor),)
//                 //                 ],
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       )),
//     );
//   }
// }

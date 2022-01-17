// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:ojos_app/core/res/width_height.dart';
// import 'package:ojos_app/features/product/domin/entities/general_item_entity.dart';
// import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:ojos_app/core/bloc/application_bloc.dart';
// import 'package:ojos_app/core/localization/translations.dart';
// import 'package:ojos_app/core/providers/cart_provider.dart';
// import 'package:ojos_app/core/res/app_assets.dart';
// import 'package:ojos_app/core/res/edge_margin.dart';
// import 'package:ojos_app/core/res/global_color.dart';
// import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
// import 'package:ojos_app/core/res/screen/vertical_padding.dart';
// import 'package:ojos_app/core/res/text_style.dart';
// import 'package:ojos_app/core/res/width_height.dart';
// import 'package:ojos_app/core/ui/dailog/add_to_cart_dialog.dart';
// import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
// import 'package:ojos_app/core/ui/tab_bar/tab_bar.dart';
// import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
// import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
// import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
// import 'package:ojos_app/features/product/domin/entities/product_details_entity.dart';
// import 'package:ojos_app/features/product/domin/entities/product_entity.dart';
// import 'package:ojos_app/features/product/domin/repositories/product_repository.dart';
// import 'package:ojos_app/features/product/domin/usecases/add_remove_favorite.dart';
// import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
// import 'package:provider/provider.dart';
// import '../../../../../main.dart';
// import '../../../domin/entities/general_item_entity.dart';
// import '../item_product_home_widget.dart';
//
// class LensesDetailsWidget extends StatefulWidget {
//   final double? width;
//   final double? height;
//   final ProductEntity product;
//   final ProductDetailsEntity productDetails;
//   final CancelToken cancelToken;
//
//   const LensesDetailsWidget(
//       {required this.height,
//       required this.width,
//       required this.product,
//       required this.productDetails,
//       required this.cancelToken});
//
//   @override
//   _LensesDetailsWidgetState createState() => _LensesDetailsWidgetState();
// }
//
// class _LensesDetailsWidgetState extends State<LensesDetailsWidget> {
//   PageController controller =
//       PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
//   var currentPageValue = 0;
//
//   /// frame Height parameters
//   bool _frameHeightValidation = false;
//   String _frameHeight = '';
//   final TextEditingController frameHeightEditingController =
//       new TextEditingController();
//
//   /// frame Width parameters
//   bool _frameWidthValidation = false;
//   String _frameWidth = '';
//   final TextEditingController frameWidthEditingController =
//       new TextEditingController();
//
//   /// frame Length parameters
//   bool _frameLengthValidation = false;
//   String _frameLength = '';
//   final TextEditingController frameLengthEditingController =
//       new TextEditingController();
//   bool? isAuth;
//
//   //SelectLensesArgs? selectLensesArgs;
//
//   bool _isDisplaySizeList = true;
//
//   List<int>? listOfColorSelected;
//
//   GeneralItemEntity? color;
//   List<int>? listOfSizeMode;
//
//   int? SizeModeId;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     listOfColorSelected = [];
//     listOfSizeMode = [];
//     color = null;
//   }
//
//   List<bool> selectsColors = [false, false, false, false, false];
//
//   @override
//   Widget build(BuildContext context) {
//     final width = widget.width ?? globalSize.setWidthPercentage(100, context);
//     final height =
//         widget.height ?? globalSize.setHeightPercentage(100, context);
//
//     isAuth =
//         BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
//             BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;
//     return Container(
//       child: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Container(
//           decoration: BoxDecoration(
//             color: globalColor.white,
//             // borderRadius: BorderRadius.all(Radius.circular(12.w))
//           ),
//           child: Column(
//             children: [
//               _buildTopWidget(
//                   context: context,
//                   width: width,
//                   height: height,
//                   discountPrice: widget.product.discount_price,
//                   discountType: widget.productDetails.discount_type,
//                   product: widget.productDetails),
//               _buildTitleAndPriceWidget(
//                 context: context,
//                 width: width,
//                 height: height,
//                 price: widget.product.price!,
//                 priceAfterDiscount: widget.product.discount_price,
//                 discountPrice: widget.product.discount_price,
//                 discountType: widget.productDetails.discount_type,
//                 name: widget.productDetails.name,
//               ),
//               // _divider(),
//               // _buildAvailableSizeWidget(
//               //     context: context,
//               //     width: width,
//               //     height: height,
//               //     list: widget.productDetails.sizeModeInfo),
//               // _divider(),
//               // _buildAvailableGlassesColors(
//               //     context: context,
//               //     width: width,
//               //     height: height,
//               //     list: widget.product.colorInfo),
//
//               // _divider(),
//               //
//               // _buildEnterDimensionsOfGlassesWidget(
//               //     context: context, width: width, height: height),
//
//               // VerticalPadding(
//               //   percentage: 2.0,
//               // ),
//               //
//               // _buildTryChooseWidget(
//               //     context: context, width: width, height: height),
//
//               // VerticalPadding(
//               //   percentage: 2.0,
//               // ),
//               //
//               // _buildGuaranteedRefundWidget(
//               //     context: context, width: width, height: height),
//
//               _divider(),
//
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "الالوان",
//                       style: textStyle.middleTSBasic.copyWith(
//                           color: Colors.black, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectsColors[0] = !selectsColors[0];
//                       });
//                     },
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                           color: Colors.black,
//                           border: Border.all(
//                               color: selectsColors[0]
//                                   ? Colors.green
//                                   : Colors.black,
//                               width: 2.w)),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectsColors[1] = !selectsColors[1];
//                       });
//                     },
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                           color: Colors.grey,
//                           border: Border.all(
//                               color:
//                                   selectsColors[0] ? Colors.green : Colors.grey,
//                               width: 2.w)),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectsColors[2] = !selectsColors[2];
//                       });
//                     },
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                           color: Colors.brown,
//                           border: Border.all(
//                               color: selectsColors[0]
//                                   ? Colors.green
//                                   : Colors.brown,
//                               width: 2.w)),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectsColors[3] = !selectsColors[3];
//                       });
//                     },
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                           color: Colors.black12,
//                           border: Border.all(
//                               color: selectsColors[0]
//                                   ? Colors.green
//                                   : Colors.black12,
//                               width: 2.w)),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectsColors[4] = !selectsColors[4];
//                       });
//                     },
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                           color: Colors.orangeAccent,
//                           border: Border.all(
//                               color: selectsColors[0]
//                                   ? Colors.green
//                                   : Colors.orangeAccent,
//                               width: 2.w)),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 8.h,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Text(
//                       "المقاسات",
//                       style: textStyle.middleTSBasic.copyWith(
//                           color: Colors.black, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.start,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 5.h,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Container(
//                     height: 40,
//                     width: 40,
//                     child: Text(
//                       'M',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     child: Text(
//                       'L',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     child: Text(
//                       'XL',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 40,
//                     width: 40,
//                     child: Text(
//                       'XXL',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 8.h,
//               ),
//
//               _buildAddToCartAndFavoriteOfferWidget(
//                   context: context,
//                   width: width,
//                   height: height,
//                   productEntity: widget.product,
//                   isAuth: isAuth!),
//
//               _divider(),
//
//               _buildSimilarProducts(
//                   context: context, width: width, height: height),
//               VerticalPadding(
//                 percentage: 2.5,
//               ),
//               // Container(
//               //   height: 140,
//               //   child: ListView.builder(
//               //     scrollDirection: Axis.horizontal,
//               //     itemBuilder: (context, index) =>
//               //         InkWell(
//               //           onTap: () {
//               //             setState(() {});
//               //             typehandlistValue = attribut
//               //                 .result!
//               //                 .typehandlist![index]
//               //                 .id!;
//               //           },
//               //           child: Column(
//               //             children: [
//               //               Image.network(
//               //                 attribut
//               //                     .result!
//               //                     .typehandlist![index]
//               //                     .image!,
//               //                 width: 40,
//               //                 height: 40,
//               //                 color: globalColor
//               //                     .primaryColor,
//               //               ),
//               //               SizedBox(height:  MediaQuery.of(context).size.height*.03,),
//               //               Text(attribut
//               //                   .result!
//               //                   .typehandlist![index]
//               //                   .name!),
//               //               Radio(
//               //                 value: attribut
//               //                     .result!
//               //                     .typehandlist![index]
//               //                     .id!,
//               //                 groupValue:
//               //                 typehandlistValue,
//               //                 onChanged: (value) {
//               //                   setState(() {
//               //                     typehandlistValue =
//               //                     value! as int;
//               //                   });
//               //                   print(
//               //                       "aaaaaaaaaaaaaaaaaa" +
//               //                           value
//               //                               .toString());
//               //                 },
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //     itemCount: attribut
//               //         .result!.typehandlist!.length,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _buildTopWidget(
//       {required BuildContext context,
//       required double width,
//       required double height,
//       required String discountType,
//       required var discountPrice,
//       required ProductDetailsEntity product}) {
//     return Container(
//       width: width,
//       height: 236.h,
//       padding: const EdgeInsets.fromLTRB(EdgeMargin.sub, EdgeMargin.verySub,
//           EdgeMargin.sub, EdgeMargin.verySub),
//       child: ClipRRect(
//         borderRadius: BorderRadius.all(Radius.circular(12.w)),
//         child: Stack(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: width,
//                   height: 236.h,
//                   child: ImageCacheWidget(
//                     imageUrl: product.image,
//                     imageWidth: width,
//                     imageHeight: 236.h,
//                     boxFit: BoxFit.fill,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 4.0,
//                   left: 4.0,
//                   child: InkWell(
//                     onTap: () async {
//                       final result = await AddOrRemoveFavorite(
//                           locator<ProductRepository>())(
//                         AddOrRemoveFavoriteParams(
//                             cancelToken: widget.cancelToken,
//                             productId: widget.product.id!),
//                       );
//                       if (result.hasDataOnly) {
//                         if (mounted)
//                           setState(() {
//                             // isRemoveFromFavorite = true;
//                             //
//                             // BlocProvider.of<ApplicationBloc>(context)
//                             //     .state
//                             //     .setRefreshFavoritePath(true);
//                             widget.productDetails.isFavorite =
//                                 !widget.productDetails.isFavorite;
//                             // widget.path.setIsFav(!widget.path.isFav);
//                           });
//                       } else if (result.hasErrorOnly || result.hasDataAndError)
//                         Fluttertoast.showToast(
//                             msg: Translations.of(context)
//                                 .translate('something_went_wrong_try_again'));
//                     },
//                     child: SvgPicture.asset(
//                       widget.productDetails.isFavorite
//                           ? AppAssets.love_fill
//                           : AppAssets.love,
//                       //color: globalColor.black,
//                       width: 35.w,
//                     ),
//                   ),
//                 )
//                 // Positioned(
//                 //   bottom: 4.0,
//                 //   right: 4.0,
//                 //   child: Container(
//                 //     decoration: BoxDecoration(
//                 //       color: globalColor.white,
//                 //       borderRadius: BorderRadius.circular(12.0.w),
//                 //     ),
//                 //     height: height * .035,
//                 //     constraints: BoxConstraints(minWidth: width * .1),
//                 //     child: Padding(
//                 //       padding: const EdgeInsets.only(left: 4.0, right: 4.0),
//                 //       child: Row(
//                 //         mainAxisAlignment: MainAxisAlignment.center,
//                 //         children: [
//                 //           SizedBox(
//                 //             width: 2,
//                 //           ),
//                 //           SvgPicture.asset(
//                 //             AppAssets.user,
//                 //             width: 16,
//                 //           ),
//                 //           SizedBox(
//                 //             width: 4,
//                 //           ),
//                 //           Text(
//                 //             product.genderId == 38
//                 //                 ? '${Translations.of(context).translate('men')}'
//                 //                 : '${Translations.of(context).translate('women')}',
//                 //             style: textStyle.minTSBasic.copyWith(
//                 //               color: globalColor.black,
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 ,
//                 Positioned(
//                   bottom: 4.0,
//                   left: 4.0,
//                   child: discountType != null && discountPrice != 0
//                       ? Container(
//                           decoration: BoxDecoration(
//                               color: globalColor.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(12.w)),
//                               border: Border.all(
//                                   color: globalColor.grey.withOpacity(0.3),
//                                   width: 0.5)),
//                           padding: const EdgeInsets.fromLTRB(
//                               EdgeMargin.subSubMin,
//                               EdgeMargin.verySub,
//                               EdgeMargin.subSubMin,
//                               EdgeMargin.verySub),
//                           child:
//                               /*discountType == 1?
//                                    Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       '${discountPrice ?? '-'} ${Translations.of(context).translate('rail')}' ??
//                                           '',
//                                       style: textStyle.smallTSBasic.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: globalColor.primaryColor),
//                                     ),
//                                     Text(
//                                         ' ${Translations.of(context).translate('discount')}',
//                                         style: textStyle.minTSBasic.copyWith(
//                                             color: globalColor.black)),
//                                   ],
//                                 )
//                               : */
//                               Row(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                   ' ${Translations.of(context).translate('discount')}',
//                                   style: textStyle.minTSBasic
//                                       .copyWith(color: globalColor.black)),
//                               Text(
//                                 '  ${discountPrice.toString()} %',
//                                 style: textStyle.smallTSBasic.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: globalColor.primaryColor),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container(),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // _buildPageIndicator2({required double width,}) {
//   //   return Container(
//   //     alignment: AlignmentDirectional.center,
//   //     width: width,
//   //     child: SmoothPageIndicator(
//   //         controller: controller, //// PageController
//   //         count: list.length,
//   //         effect: WormEffect(
//   //           spacing: 4.0,
//   //           radius: 10.0,
//   //           dotWidth: 10.0,
//   //           dotHeight: 10.0,
//   //           dotColor: Colors.white,
//   //           paintStyle: PaintingStyle.fill,
//   //           strokeWidth: 2,
//   //           activeDotColor: globalColor.primaryColor,
//   //         ), // your preferred effect
//   //         onDotClicked: (index) {}),
//   //   );
//   // }
//
//   _buildTitleAndPriceWidget({
//     required BuildContext context,
//     required double width,
//     required double height,
//     required int price,
//     required var priceAfterDiscount,
//     required var discountPrice,
//     required String discountType,
//     required String name,
//   }) {
//     return Container(
//       width: width,
//       padding:
//           const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//       child: Column(
//         children: [
//           Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 VerticalPadding(
//                   percentage: 1.5,
//                 ),
//                 Container(
//                   child: Text(
//                     '${name ?? ''}' ?? '',
//                     style: textStyle.middleTSBasic.copyWith(
//                       color: globalColor.black,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                   alignment: AlignmentDirectional.centerStart,
//                 ),
//                 // Container(
//                 //   child: Row(
//                 //     crossAxisAlignment: CrossAxisAlignment.center,
//                 //     children: [
//                 //       isFree != null && isFree
//                 //           ? Container(
//                 //               width: 15.w,
//                 //               height: 15.w,
//                 //               decoration: BoxDecoration(
//                 //                   color: globalColor.goldColor,
//                 //                   shape: BoxShape.circle,
//                 //                   border: Border.all(
//                 //                       width: 1.0,
//                 //                       color: globalColor.primaryColor)),
//                 //               child: Icon(
//                 //                 MaterialIcons.check,
//                 //                 color: globalColor.black,
//                 //                 size: 10.w,
//                 //               ),
//                 //             )
//                 //           : Container(
//                 //               width: 15.w,
//                 //               height: 15.w,
//                 //               decoration: BoxDecoration(
//                 //                   color: globalColor.grey,
//                 //                   shape: BoxShape.circle,
//                 //                   border: Border.all(
//                 //                       width: 1.0,
//                 //                       color: globalColor.grey
//                 //                           .withOpacity(0.3))),
//                 //               child: Center(
//                 //                 child: Text(''),
//                 //               ),
//                 //             ),
//                 //       Container(
//                 //           padding: const EdgeInsets.only(
//                 //               left: EdgeMargin.sub, right: EdgeMargin.sub),
//                 //           child: Text(
//                 //             '${Translations.of(context).translate('free_lenses')}' ??
//                 //                 '',
//                 //             style: textStyle.minTSBasic.copyWith(
//                 //                 fontWeight: FontWeight.w500,
//                 //                 color: globalColor.grey),
//                 //           ))
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//           Container(
//               //  alignment: AlignmentDirectional.centerEnd,
//               padding: const EdgeInsets.fromLTRB(EdgeMargin.verySub,
//                   EdgeMargin.sub, EdgeMargin.verySub, EdgeMargin.sub),
//               alignment: AlignmentDirectional.centerStart,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.fromLTRB(
//                         EdgeMargin.subSubMin,
//                         EdgeMargin.verySub,
//                         EdgeMargin.subSubMin,
//                         EdgeMargin.verySub),
//                     child: _buildPriceWidget(
//                         discountPrice: discountPrice,
//                         price: price,
//                         priceAfterDiscount: priceAfterDiscount),
//                   ),
//                 ],
//               )),
//         ],
//       ),
//     );
//   }
//
//   // _buildAvailableSizeWidget(
//   //     {BuildContext context,
//   //     double width,
//   //     double height,
//   //     List<GeneralItemEntity> list}) {
//   //   if (list != null && list.isNotEmpty) {
//   //     return Container(
//   //       width: width,
//   //       padding:
//   //           const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           Container(
//   //             padding: const EdgeInsets.fromLTRB(
//   //                 EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//   //             child: Row(
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               children: [
//   //                 Expanded(
//   //                   flex: 1,
//   //                   child: Container(
//   //                     child: Text(
//   //                       Translations.of(context).translate('available_sizes') ??
//   //                           '',
//   //                       style: textStyle.middleTSBasic.copyWith(
//   //                         color: globalColor.black,
//   //                         fontWeight: FontWeight.w600,
//   //                       ),
//   //                       overflow: TextOverflow.ellipsis,
//   //                       maxLines: 1,
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 Container(
//   //                   decoration: BoxDecoration(
//   //                       shape: BoxShape.circle,
//   //                       color: globalColor.grey.withOpacity(0.5)),
//   //                   child: Center(
//   //                     child: Icon(
//   //                       MaterialIcons.keyboard_arrow_down,
//   //                       color: globalColor.black,
//   //                     ),
//   //                   ),
//   //                 )
//   //               ],
//   //             ),
//   //           ),
//   //           VerticalPadding(
//   //             percentage: .5,
//   //           ),
//   //           Container(
//   //             child: ListView.builder(
//   //                 shrinkWrap: true,
//   //                 itemCount: list.length,
//   //                 physics: NeverScrollableScrollPhysics(),
//   //                 itemBuilder: (context, index) {
//   //                   return _buildSizeItem(
//   //                       width: width,
//   //                       image: AppAssets.glasses_svg,
//   //                       context: context,
//   //                       height: height,
//   //                       isAvailable: true,
//   //                       label: list[index].name ?? '',
//   //                       size: list[index].value ?? '',
//   //                       imageSize: 42.w);
//   //                 }),
//   //           ),
//   //           // Container(
//   //           //   child: Column(
//   //           //     children: [
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: true,
//   //           //           label: 'SMALL'.toUpperCase(),
//   //           //           size: '40-48',
//   //           //           imageSize: 42.w),
//   //           //       VerticalPadding(
//   //           //         percentage: 1.0,
//   //           //       ),
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: false,
//   //           //           label: 'Medium'.toUpperCase(),
//   //           //           size: '49-54',
//   //           //           imageSize: 55.w),
//   //           //       VerticalPadding(
//   //           //         percentage: 1.0,
//   //           //       ),
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: true,
//   //           //           label: 'Large'.toUpperCase(),
//   //           //           size: '55-58',
//   //           //           imageSize: 65.w),
//   //           //       VerticalPadding(
//   //           //         percentage: 1.0,
//   //           //       ),
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: false,
//   //           //           label: 'E-Large'.toUpperCase(),
//   //           //           size: 'above 58',
//   //           //           imageSize: 80.w),
//   //           //     ],
//   //           //   ),
//   //           // )
//   //         ],
//   //       ),
//   //     );
//   //   }
//   //   return Container();
//   // }
//   //
//   // _buildAvailableSizeWidget(
//   //     {BuildContext context,
//   //     double width,
//   //     double height,
//   //     List<GeneralItemEntity> list}) {
//   //   if (list != null && list.isNotEmpty) {
//   //     return Container(
//   //       width: width,
//   //       padding:
//   //           const EdgeInsets.fromLTRB(0.0, EdgeMargin.sub, 0.0, EdgeMargin.sub),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.start,
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           InkWell(
//   //             onTap: () {
//   //               if (mounted)
//   //                 setState(() {
//   //                   _isDisplaySizeList = !_isDisplaySizeList;
//   //                 });
//   //             },
//   //             child: Container(
//   //               padding: const EdgeInsets.fromLTRB(
//   //                   EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//   //               child: Row(
//   //                 crossAxisAlignment: CrossAxisAlignment.center,
//   //                 children: [
//   //                   Expanded(
//   //                     flex: 1,
//   //                     child: Container(
//   //                       child: Text(
//   //                         Translations.of(context)
//   //                                 .translate('available_sizes') ??
//   //                             '',
//   //                         style: textStyle.middleTSBasic.copyWith(
//   //                           color: globalColor.black,
//   //                           fontWeight: FontWeight.w600,
//   //                         ),
//   //                         overflow: TextOverflow.ellipsis,
//   //                         maxLines: 1,
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   Container(
//   //                     decoration: BoxDecoration(
//   //                         shape: BoxShape.circle,
//   //                         color: globalColor.grey.withOpacity(0.5)),
//   //                     child: Center(
//   //                       child: Icon(
//   //                         !_isDisplaySizeList
//   //                             ? Icons.keyboard_arrow_down
//   //                             : Icons.keyboard_arrow_up,
//   //                         color: globalColor.black,
//   //                       ),
//   //                     ),
//   //                   )
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //           VerticalPadding(
//   //             percentage: .5,
//   //           ),
//   //           _isDisplaySizeList
//   //               ? Container(
//   //                   child: ListView.builder(
//   //                       shrinkWrap: true,
//   //                       itemCount: list.length,
//   //                       physics: NeverScrollableScrollPhysics(),
//   //                       itemBuilder: (context, index) {
//   //                         return ItemSizeProductDetails(
//   //                           width: width,
//   //                           item: list[index],
//   //                           isSelected: SizeModeId == list[index].id,
//   //                           onSelect: _onSelectSize,
//   //                         );
//   //                       }),
//   //                 )
//   //               : Container(),
//   //           // Container(
//   //           //   child: Column(
//   //           //     children: [
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: true,
//   //           //           label: 'SMALL'.toUpperCase(),
//   //           //           size: '40-48',
//   //           //           imageSize: 42.w),
//   //           //       VerticalPadding(
//   //           //         percentage: 1.0,
//   //           //       ),
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: false,
//   //           //           label: 'Medium'.toUpperCase(),
//   //           //           size: '49-54',
//   //           //           imageSize: 55.w),
//   //           //       VerticalPadding(
//   //           //         percentage: 1.0,
//   //           //       ),
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: true,
//   //           //           label: 'Large'.toUpperCase(),
//   //           //           size: '55-58',
//   //           //           imageSize: 65.w),
//   //           //       VerticalPadding(
//   //           //         percentage: 1.0,
//   //           //       ),
//   //           //       _buildSizeItem(
//   //           //           width: width,
//   //           //           image: AppAssets.glasses_svg,
//   //           //           context: context,
//   //           //           height: height,
//   //           //           isAvailable: false,
//   //           //           label: 'E-Large'.toUpperCase(),
//   //           //           size: 'above 58',
//   //           //           imageSize: 80.w),
//   //           //     ],
//   //           //   ),
//   //           // )
//   //         ],
//   //       ),
//   //     );
//   //   }
//   //   return Container();
//   // }
//
//   _onSelectSize(GeneralItemEntity size, bool isSelected) {
//     if (isSelected) {
//       if (mounted) {
//         setState(() {
//           SizeModeId = size.id;
//           //  listOfSizeMode.add(size.id);
//         });
//       }
//     } else {
//       if (mounted)
//         setState(() {
//           //  listOfSizeMode.removeWhere((element) => element == size.id);
//         });
//     }
//
//     // print('listOfSizeMode ${listOfSizeMode.toString()}');
//   }
//
//   // _buildSizeItem(
//   //     {BuildContext context,
//   //     double width,
//   //     double height,
//   //     bool isAvailable,
//   //     String label,
//   //     String size,
//   //     String image,
//   //     double imageSize}) {
//   //   double sizeIcon;
//   //   if (size == '40-48') {
//   //     sizeIcon = 42.w;
//   //   } else if (size == '49-54') {
//   //     sizeIcon = 55.w;
//   //   } else if (size == '55-58') {
//   //     sizeIcon = 65.w;
//   //   } else if (size == 'above 58') {
//   //     sizeIcon = 80.w;
//   //   } else {
//   //     sizeIcon = 42.w;
//   //   }
//   //   return Container(
//   //     padding:
//   //         const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//   //     width: width,
//   //     height: 46.h,
//   //     child: Row(
//   //       children: [
//   //         Expanded(
//   //           flex: 7,
//   //           child: Container(
//   //             decoration: BoxDecoration(
//   //               color: globalColor.white.withOpacity(0.5),
//   //               borderRadius: BorderRadius.only(
//   //                   bottomRight: utils.getLang() == 'ar'
//   //                       ? Radius.circular(10.w)
//   //                       : Radius.circular(0.0),
//   //                   topRight: utils.getLang() == 'ar'
//   //                       ? Radius.circular(10.w)
//   //                       : Radius.circular(0.0),
//   //                   bottomLeft: utils.getLang() == 'ar'
//   //                       ? Radius.circular(0.0)
//   //                       : Radius.circular(10.w),
//   //                   topLeft: utils.getLang() == 'ar'
//   //                       ? Radius.circular(0.0)
//   //                       : Radius.circular(10.w)),
//   //               border: Border.all(
//   //                   color: globalColor.grey.withOpacity(0.3), width: 0.5),
//   //             ),
//   //             height: 46.h,
//   //             child: Row(
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               mainAxisAlignment: MainAxisAlignment.start,
//   //               children: [
//   //                 HorizontalPadding(
//   //                   percentage: 1.0,
//   //                 ),
//   //                 Container(
//   //                   width: 25.w,
//   //                   height: 25.w,
//   //                   decoration: BoxDecoration(
//   //                       color: isAvailable
//   //                           ? globalColor.primaryColor
//   //                           : globalColor.white,
//   //                       shape: BoxShape.circle,
//   //                       border: Border.all(
//   //                           width: 0.5,
//   //                           color: isAvailable
//   //                               ? globalColor.primaryColor.withOpacity(0.3)
//   //                               : globalColor.grey.withOpacity(0.3))),
//   //                   child: Center(
//   //                     child: CircleAvatar(
//   //                       child: isAvailable
//   //                           ? Icon(
//   //                               MaterialIcons.check,
//   //                               color: globalColor.black,
//   //                               size: 12,
//   //                             )
//   //                           : Container(),
//   //                       radius: isAvailable ? 15.w : 9.w,
//   //                       backgroundColor: isAvailable
//   //                           ? globalColor.goldColor
//   //                           : globalColor.grey.withOpacity(0.3),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 HorizontalPadding(
//   //                   percentage: 1.0,
//   //                 ),
//   //                 Container(
//   //                   child: Text(
//   //                     label ?? '',
//   //                     style: textStyle.smallTSBasic.copyWith(
//   //                         color: globalColor.black,
//   //                         fontWeight: FontWeight.w500),
//   //                   ),
//   //                 )
//   //               ],
//   //             ),
//   //           ),
//   //         ),
//   //         Expanded(
//   //           flex: 6,
//   //           child: Container(
//   //             decoration: BoxDecoration(
//   //               color: globalColor.white.withOpacity(0.5),
//   //               border: Border(
//   //                 top: BorderSide(
//   //                     color: globalColor.grey.withOpacity(0.3), width: 0.5),
//   //                 bottom: BorderSide(
//   //                     color: globalColor.grey.withOpacity(0.3), width: 0.5),
//   //               ),
//   //             ),
//   //             height: 46.h,
//   //             alignment: AlignmentDirectional.center,
//   //             //color: globalColor.white,
//   //             child: Text(
//   //               size ?? '',
//   //               style: textStyle.middleTSBasic.copyWith(
//   //                   color: globalColor.grey.withOpacity(0.8),
//   //                   fontWeight: FontWeight.bold),
//   //             ),
//   //           ),
//   //         ),
//   //         Expanded(
//   //           flex: 6,
//   //           child: Container(
//   //             alignment: AlignmentDirectional.center,
//   //             decoration: BoxDecoration(
//   //               color: globalColor.grey.withOpacity(0.1),
//   //               borderRadius: BorderRadius.only(
//   //                   bottomRight: utils.getLang() == 'ar'
//   //                       ? Radius.circular(0.0)
//   //                       : Radius.circular(10.w),
//   //                   topRight: utils.getLang() == 'ar'
//   //                       ? Radius.circular(0.0)
//   //                       : Radius.circular(10.w),
//   //                   bottomLeft: utils.getLang() == 'ar'
//   //                       ? Radius.circular(10.w)
//   //                       : Radius.circular(0.0),
//   //                   topLeft: utils.getLang() == 'ar'
//   //                       ? Radius.circular(10.w)
//   //                       : Radius.circular(0.0)),
//   //               border: Border.all(
//   //                   color: globalColor.grey.withOpacity(0.3), width: 0.5),
//   //             ),
//   //             height: 46.h,
//   //             child: SvgPicture.asset(
//   //               image ?? '',
//   //               width: sizeIcon ?? 10.w,
//   //             ),
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   //
//   // _buildAvailableGlassesColors(
//   //     {BuildContext context,
//   //     double width,
//   //     double height,
//   //     List<GeneralItemEntity> list}) {
//   //   if (list != null && list.isNotEmpty) {
//   //     Wrap body = Wrap(
//   //         // alignment: WrapAlignment.start,
//   //         // runAlignment: WrapAlignment.start,
//   //         crossAxisAlignment: WrapCrossAlignment.center,
//   //         children: [
//   //           Container(
//   //             padding: const EdgeInsets.fromLTRB(
//   //                 EdgeMargin.sub, 0.0, EdgeMargin.sub, 0.0),
//   //             child: Row(
//   //               children: [
//   //                 Container(
//   //                   child: Text(
//   //                     Translations.of(context).translate('available_colors') ??
//   //                         '',
//   //                     style: textStyle.middleTSBasic.copyWith(
//   //                       color: globalColor.black,
//   //                       fontWeight: FontWeight.w600,
//   //                     ),
//   //                     overflow: TextOverflow.ellipsis,
//   //                     maxLines: 1,
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ]);
//   //
//   //     body.children.addAll(list.map((item) {
//   //       return ItemColorProductDetails(
//   //         onSelect: _onSelectColors,
//   //         item: item,
//   //         isSelected: color?.id == item.id,
//   //       );
//   //     }));
//   //     return Container(
//   //         width: width,
//   //         padding: const EdgeInsets.fromLTRB(
//   //             EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//   //         child: body);
//   //   }
//   //
//   //   return Container();
//   // }
//
//   _onSelectColors(GeneralItemEntity colors, bool isSelected) {
//     if (isSelected) {
//       if (mounted) {
//         setState(() {
//           color = colors;
//           // listOfColorSelected.add(colors.id);
//         });
//       }
//     } else {
//       if (mounted)
//         setState(() {
//           // listOfColorSelected.removeWhere((element) => element == colors.id);
//         });
//     }
//
//     //  print('listOfYourSelected ${listOfColorSelected.toString()}');
//   }
//
//   _buildAddToCartAndFavoriteWidget(
//       {required BuildContext context,
//       required double width,
//       required double height,
//       required ProductEntity productEntity,
//       required bool isAuth}) {
//     return Container(
//       padding:
//           const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Consumer<CartProvider>(
//             builder: (context, quizProvider, child) {
//               return Expanded(
//                 flex: 3,
//                 child: InkWell(
//                   onTap: () async {
//                     if (await UserRepository.hasToken && isAuth) {
//                       // if((color!=null&&color.id!=null) && SizeModeId!=null ){
//                       //
//                       //
//                       // }else{
//                       //   appConfig.showToast(msg:Translations.of(context).translate('you_must_choose_size_and_color'));
//                       // }
//
//                       quizProvider.addItemToCart(CartEntity(
//                           id: productEntity.id!,
//                           productEntity: productEntity,
//                           // isGlasses: productEntity.isGlasses,
//                           // colorId: color?.id,
//                           // lensSize: null,
//                           // sizeForLeftEye: null,
//                           // SizeModeId: SizeModeId,
//                           // sizeForRightEye: null,
//                           // argsForGlasses: selectLensesArgs,
//                           count: 1));
//                       print('${quizProvider.getItems()!.length}');
//                       showDialog(
//                         context: context,
//                         builder: (ctx) => AddToCartDialog(),
//                       );
//                     } else {
//                       showDialog(
//                         context: context,
//                         builder: (ctx) => LoginFirstDialog(),
//                       );
//                     }
//
//                     // quizProvider.addItemToCart(CartEntity(
//                     //     id: productEntity.id,
//                     //     productEntity: productEntity,
//                     //     isGlasses: productEntity.isGlasses,
//                     //     addSize: null,
//                     //     ipdSize: null,
//                     //     sizeForLeftEye: null,
//                     //     sizeForRightEye: null,
//                     //     count: 1));
//                     // print('${quizProvider.getItems().length}');
//                     // showDialog(
//                     //   context: context,
//                     //   builder: (ctx) => AddToCartDialog(),
//                     // );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: globalColor.primaryColor,
//                       borderRadius: BorderRadius.circular(16.0.w),
//                       // border: Border.all(
//                       //     width: 0.5,
//                       //     color: globalColor.grey.withOpacity(0.3))
//                     ),
//                     height: 40.w,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             Translations.of(context).translate('add_to_cart'),
//                             style: textStyle.smallTSBasic.copyWith(
//                                 fontWeight: FontWeight.w500,
//                                 color: globalColor.white),
//                           ),
//                         ),
//                         SvgPicture.asset(
//                           AppAssets.cart_nav_bar,
//                           color: globalColor.white,
//                           width: 20.w,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   _buildAddToCartAndFavoriteOfferWidget(
//       {required BuildContext context,
//       required double width,
//       required double height,
//       required ProductEntity productEntity,
//       required bool isAuth}) {
//     return Container(
//       padding:
//           const EdgeInsets.fromLTRB(EdgeMargin.min, 0.0, EdgeMargin.min, 0.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Consumer<CartProvider>(
//             builder: (context, quizProvider, child) {
//               return Expanded(
//                 flex: 3,
//                 child: InkWell(
//                   onTap: () async {
//                     if (await UserRepository.hasToken && isAuth) {
//                       quizProvider.addItemToCart(CartEntity(
//                           id: productEntity.id!,
//                           productEntity: ProductEntity(
//                               discount_type: '',
//                               name: productEntity.name,
//                               image: productEntity.image,
//                               rate: '',
//                               review_count: 0,
//                               isReview: true,
//                               isFavorite: false,
//                               product_as_same: [],
//                               quantity: null,
//                               price: productEntity.price,
//                               discount_price: productEntity.discount_price,
//                               category_id: productEntity.category_id,
//                               is_new: null,
//                               description: '',
//                               id: productEntity.id),
//                           // isGlasses: productEntity.isGlasses,
//                           // colorId: color?.id,
//                           // lensSize: null,
//                           // sizeForLeftEye: null,
//                           // SizeModeId: SizeModeId,
//                           // sizeForRightEye: null,
//                           // argsForGlasses: selectLensesArgs,
//                           count: 1));
//                       print('${quizProvider.getItems()!.length}');
//                       showDialog(
//                         context: context,
//                         builder: (ctx) => AddToCartDialog(),
//                       );
//                     } else {
//                       showDialog(
//                         context: context,
//                         builder: (ctx) => LoginFirstDialog(),
//                       );
//                     }
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: globalColor.primaryColor,
//                       borderRadius: BorderRadius.circular(16.0.w),
//                       // border: Border.all(
//                       //     width: 0.5,
//                       //     color: globalColor.grey.withOpacity(0.3))
//                     ),
//                     height: 40.w,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             Translations.of(context).translate('add_to_cart'),
//                             style: textStyle.smallTSBasic.copyWith(
//                                 fontWeight: FontWeight.w500,
//                                 color: globalColor.white),
//                           ),
//                         ),
//                         SvgPicture.asset(
//                           AppAssets.cart_nav_bar,
//                           color: globalColor.white,
//                           width: 20.w,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           SizedBox(
//             width: 5.w,
//           ),
//           Consumer<CartProvider>(
//             builder: (context, quizProvider, child) {
//               return Expanded(
//                 flex: 3,
//                 child: InkWell(
//                   onTap: () async {
//                     //  if (await UserRepository.hasToken && isAuth) {
//                     // if((color!=null&&color.id!=null) && SizeModeId!=null ){
//                     //
//                     //
//                     // }else{
//                     //   appConfig.showToast(msg:Translations.of(context).translate('you_must_choose_size_and_color'));
//                     // }
//
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => TabBarDemo(),
//                         ));
//                     /* quizProvider.addItemToCart(CartEntity(
//                           id: productEntity.id,
//                           productEntity: ProductEntity(
//                               discount_type: '',
//                               name: productEntity.name,
//                               image: productEntity.image,
//                               rate: '',
//                               review_count: 0,
//                               isReview: true,
//                               isFavorite: false,
//                               product_as_same: [],
//                               quantity: null,
//                               price: productEntity.price,
//                               discount_price: productEntity.discount_price,
//                               category_id: productEntity.category_id,
//                               is_new: null,
//                               description: '',
//                               id: productEntity.id),
//                           // isGlasses: productEntity.isGlasses,
//                           // colorId: color?.id,
//                           // lensSize: null,
//                           // sizeForLeftEye: null,
//                           // SizeModeId: SizeModeId,
//                           // sizeForRightEye: null,
//                           // argsForGlasses: selectLensesArgs,
//                           count: 1));
//                       print('${quizProvider.getItems()!.length}');
//                       showDialog(
//                         context: context,
//                         builder: (ctx) => AddToCartDialog(),
//                       );*/
//                     // } else {
//                     //
//                     //   showDialog(
//                     //     context: context,
//                     //     builder: (ctx) => LoginFirstDialog(),
//                     //   );
//                     // }
//
//                     // quizProvider.addItemToCart(CartEntity(
//                     //     id: productEntity.id,
//                     //     productEntity: productEntity,
//                     //     isGlasses: productEntity.isGlasses,
//                     //     addSize: null,
//                     //     ipdSize: null,
//                     //     sizeForLeftEye: null,
//                     //     sizeForRightEye: null,
//                     //     count: 1));
//                     // print('${quizProvider.getItems().length}');
//                     // showDialog(
//                     //   context: context,
//                     //   builder: (ctx) => AddToCartDialog(),
//                     // );
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: globalColor.primaryColor,
//                       borderRadius: BorderRadius.circular(16.0.w),
//                       // border: Border.all(
//                       //     width: 0.5,
//                       //     color: globalColor.grey.withOpacity(0.3))
//                     ),
//                     height: 40.w,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             Translations.of(context).translate('making'),
//                             style: textStyle.smallTSBasic.copyWith(
//                                 fontWeight: FontWeight.w500,
//                                 color: globalColor.white),
//                           ),
//                         ),
//                         // SvgPicture.asset(
//                         //   AppAssets.cart_nav_bar,
//                         //   color: globalColor.white,
//                         //   width: 20.w,
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   _buildSimilarProducts(
//       {required BuildContext context,
//       required double width,
//       required double height}) {
//     return Container(
//       child: widget.productDetails.product_as_same != null &&
//               widget.productDetails.product_as_same.isNotEmpty
//           ? Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: EdgeMargin.small, right: EdgeMargin.small),
//                   child: TitleWithViewAllWidget(
//                     width: width,
//                     title:
//                         Translations.of(context).translate('similar_products'),
//                     onClickView: () {},
//                     strViewAll: Translations.of(context).translate('view_all'),
//                   ),
//                 ),
//                 Container(
//                     child: GridView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: widget.productDetails.product_as_same.length,
//                         shrinkWrap: true,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 1,
//                           mainAxisSpacing: 1,
//                           childAspectRatio:
//                               globalSize.setWidthPercentage(47, context) /
//                                   globalSize.setWidthPercentage(60, context),
//                         ),
//                         itemBuilder: (BuildContext context, int index) {
//                           return ItemProductHomeWidget(
//                             fromHome: true,
//                             height: globalSize.setWidthPercentage(60, context),
//                             width: globalSize.setWidthPercentage(47, context),
//                             product:
//                                 widget.productDetails.product_as_same[index],
//                           );
//                         }))
//               ],
//             )
//           : Container(),
//     );
//   }
//
//   _divider() {
//     return Divider(
//       color: globalColor.grey.withOpacity(0.3),
//       height: 8.h,
//     );
//   }
//
//   _buildPriceWidget(
//       {required int price,
//       required var discountPrice,
//       required var priceAfterDiscount}) {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           discountPrice != null && discountPrice != 0.0
//               ? Container(
//                   child: FittedBox(
//                   child: RichText(
//                     text: TextSpan(
//                       text: '${price.toString() ?? ''}',
//                       style: textStyle.middleTSBasic.copyWith(
//                           fontWeight: FontWeight.bold,
//                           decoration: TextDecoration.lineThrough,
//                           color: globalColor.grey),
//                       children: <TextSpan>[
//                         new TextSpan(
//                             text:
//                                 ' ${Translations.of(context).translate('rail')}',
//                             style: textStyle.smallTSBasic
//                                 .copyWith(color: globalColor.grey)),
//                       ],
//                     ),
//                   ),
//                 ))
//               : Container(
//                   child: FittedBox(
//                   child: RichText(
//                     text: TextSpan(
//                       text: price.toString() ?? '',
//                       style: textStyle.middleTSBasic.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: globalColor.primaryColor),
//                       children: <TextSpan>[
//                         new TextSpan(
//                             text:
//                                 ' ${Translations.of(context).translate('rail')}',
//                             style: textStyle.smallTSBasic
//                                 .copyWith(color: globalColor.black)),
//                       ],
//                     ),
//                   ),
//                 )),
//           HorizontalPadding(percentage: 2.5),
//           discountPrice != null && discountPrice != 0.0
//               ? Container(
//                   child: FittedBox(
//                   child: RichText(
//                     text: TextSpan(
//                       text: priceAfterDiscount.toString(),
//                       style: textStyle.middleTSBasic.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: globalColor.primaryColor),
//                       children: <TextSpan>[
//                         new TextSpan(
//                             text:
//                                 ' ${Translations.of(context).translate('rail')}',
//                             style: textStyle.smallTSBasic
//                                 .copyWith(color: globalColor.black)),
//                       ],
//                     ),
//                   ),
//                 ))
//               : Container(),
//         ],
//       ),
//     );
//   }
// }

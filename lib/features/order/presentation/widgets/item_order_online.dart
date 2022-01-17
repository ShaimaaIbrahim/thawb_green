import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/dailog/confirm_dialog.dart';
import 'package:ojos_app/core/ui/widget/image/image_caching.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/features/order/presentation/blocs/order_online_ploc.dart';
import 'package:ojos_app/features/order/presentation/pages/order_detail_page_online.dart';

class ItemOrderWidgetOnline extends StatefulWidget {
  final GeneralOrderItemEntity orderItem;
  final CancelToken cancelToken;
  final Function onUpdate;
  final Map<String, String> filterparams;
  final OrderBlocOnline orderBloc;

  const ItemOrderWidgetOnline(
      {required this.orderItem,
      required this.onUpdate,
      required this.filterparams,
      required this.orderBloc,
      required this.cancelToken});

  @override
  _ItemOrderWidgetOnlineState createState() => _ItemOrderWidgetOnlineState();
}

class _ItemOrderWidgetOnlineState extends State<ItemOrderWidgetOnline> {
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    double width = globalSize.setWidthPercentage(95, context);
    return isDeleted
        ? Container()
        : InkWell(
            onTap: () {
              Get.Get.toNamed(OrderDetailsPageOnline.routeName,
                  arguments: widget.orderItem);
            },
            child: Container(
              width: width,
              padding: EdgeInsets.only(
                  left: EdgeMargin.subMin, right: EdgeMargin.subMin),
              child: Card(
                color: globalColor.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0.w))),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.0.w)),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: EdgeMargin.subMin,
                              right: EdgeMargin.subMin,
                              bottom: EdgeMargin.subMin,
                              top: EdgeMargin.subMin),
                          width: width,
                          child: Column(
                            children: [
                              Container(
                                height: 144.h,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 144.h,
                                          width: 144.h,
                                          child: ImageCacheWidget(
                                            imageUrl:
                                                widget.orderItem.orderimage,
                                            imageWidth: 10.w,
                                            imageHeight: 144.h,
                                            imageBorderRadius: 12.w,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${Translations.of(context).translate('order_date')}',
                                                  style: textStyle.minTSBasic
                                                      .copyWith(
                                                    color: globalColor.black,
                                                  ),
                                                ),
                                                Text(
                                                  widget.orderItem.order_date,
                                                  style: textStyle.minTSBasic
                                                      .copyWith(
                                                    color: globalColor.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${Translations.of(context).translate('order_no')}',
                                                  style: textStyle.minTSBasic
                                                      .copyWith(
                                                    color: globalColor.black,
                                                  ),
                                                ),
                                                Text(
                                                  widget.orderItem.uid,
                                                  style: textStyle.minTSBasic
                                                      .copyWith(
                                                    color: globalColor.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: globalColor
                                                          .primaryColor),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 2,
                                                        horizontal: 15),
                                                    child: Text(
                                                      //'${Translations.of(context).translate('delivery_stage')}',
                                                      _getStrStatus(
                                                          context: context,
                                                          status: widget
                                                              .orderItem
                                                              .status),
                                                      style: textStyle
                                                          .minTSBasic
                                                          .copyWith(
                                                              color: globalColor
                                                                  .white),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (ctx) =>
                                                            ConfirmDialog(
                                                          title: Translations
                                                                  .of(context)
                                                              .translate(
                                                                  'delete_order'),
                                                          confirmMessage:
                                                              Translations.of(
                                                                      context)
                                                                  .translate(
                                                                      'are_you_sure_delete_order'),
                                                          actionYes: () {
                                                            Get.Get.back();
                                                            widget.orderBloc.add(
                                                                DeleteOrderEvent(
                                                                    filterparams:
                                                                        widget
                                                                            .filterparams,
                                                                    cancelToken:
                                                                        widget
                                                                            .cancelToken,
                                                                    id: widget
                                                                        .orderItem
                                                                        .id));
                                                          },
                                                          actionNo: () {
                                                            setState(() {
                                                              Get.Get.back();
                                                            });
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(Icons.delete,
                                                        color: Colors.red,
                                                        size: 20))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: globalColor.primaryColor,
                          height: 5.0,
                          thickness: .5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BuildStepsWidgetOnline(
                              width, widget.orderItem.status),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  _getStrStatus({required BuildContext context, required String status}) {
    switch (status) {
      case "accepted":
        return "اخذ المقاسات";
        break;
      case "canceled":
        return "اخذ المقاسات";
        break;
      case "pending":
        return "اخذ المقاسات";
        break;
      // case 4:
      //   return Translations.of(context).translate('delivered');
      //   break;
      // case 5:
      //   return Translations.of(context).translate('canceled');
      //   break;
      // case 6:
      //   return Translations.of(context).translate('cancel_requested');
      //   break;
      // case 7:
      //   return Translations.of(context).translate('refunded');
      //   break;
      default:
        return Translations.of(context).translate('received');
        break;
    }
  }
}

class BuildStepsWidgetOnline extends StatelessWidget {
  final double? width;
  final String? statues;

  BuildStepsWidgetOnline(this.width, this.statues);

  @override
  Widget build(BuildContext context) {
    if (statues == "pending")
      return IsTakeMeasurements();
    else if (statues == "accepted")
      return IsBill();
    else if (statues == "shipped")
      return IsUnderway();
    else if (statues == "complated")
      return IsCharged();
    else
      return IsTakeMeasurements();
  }
}

class IsTakeMeasurements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.edit,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('take_measurements'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.grey.withOpacity(.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.description,
                color: globalColor.black,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Bill'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.grey.withOpacity(.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: CupertinoActivityIndicator(
                animating: false,
                radius: 10,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Underway'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.grey.withOpacity(.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.send,
                color: globalColor.black,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('charged'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class IsBill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.edit,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('take_measurements'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.description,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Bill'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.grey.withOpacity(.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: CupertinoActivityIndicator(
                animating: false,
                radius: 10,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Underway'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.grey.withOpacity(.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.send,
                color: globalColor.black,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('charged'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class IsUnderway extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.edit,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('take_measurements'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.description,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Bill'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: CupertinoActivityIndicator(
                animating: false,
                radius: 10,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Underway'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.grey.withOpacity(.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.send,
                color: globalColor.black,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('charged'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class IsCharged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.edit,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('take_measurements'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.description,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Bill'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: CupertinoActivityIndicator(
                animating: false,
                radius: 10,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('Underway'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Expanded(
            child: Container(
          height: 1.0,
          color: globalColor.black,
        )),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: globalColor.accentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: globalColor.grey.withOpacity(0.2), width: 1.0)),
              width: 40.w,
              height: 40,
              child: Icon(
                Icons.send,
                color: globalColor.white,
                size: 25.w,
              ),
            ),
            Container(
              child: Text(
                Translations.of(context).translate('charged'),
                style: textStyle.subMinTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
  }
}

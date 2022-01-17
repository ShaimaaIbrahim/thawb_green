import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as Get;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/datasources/concrete_core_remote_data_source.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/features/order/data/models/general_order_item_model.dart';
import 'package:ojos_app/features/order/data/models/general_order_item_model_online.dart';
import 'package:ojos_app/features/order/data/models/order_details_online.dart';
import 'package:ojos_app/features/order/domain/entities/general_order_item_entity.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/order_item_entity.dart';

class OrderDetailsPageOnline extends StatefulWidget {
  static const routeName = '/order/pages/OrderDetailsPageOnline';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<OrderDetailsPageOnline> {
  double? latitude;
  double? longitude;
  final args = Get.Get.arguments as GeneralOrderItemEntity;

  @override
  void initState() {
    super.initState();
    // latitude = args.user_address.latitude;
    // longitude = args.user_address.longitude;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

  ///===========================================================================

  Set<Marker> markers = {};

  /// initial position
  CameraPosition _initialLocation = CameraPosition(
      target: LatLng(34.80207500000000209183781407773494720458984375,
          38.996814999999998008206603117287158966064453125),
      zoom: 13);
  Completer<GoogleMapController> _mapController = Completer();

  ///
  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor? pinLocationIcon;

  ///
  GoogleMapController? mapController;

  ///
  Position? _currentPosition;
  String? _currentAddress;

  Permission _permission = Permission.location;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = Position(
          latitude: latitude!,
          longitude: longitude!,
          timestamp: null,
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          floor: 0,
          isMocked: false,
        );
        print('CURRENT POS: $_currentPosition');
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude!, longitude!),
              // target: LatLng(40.732128, -73.999619),
              zoom: 13.0,
            ),
          ),
        );

        markers.add(Marker(
            markerId: MarkerId('current_Postion'),
            infoWindow: InfoWindow(title: 'Current Position'),
            position: LatLng(position.latitude, position.longitude),
            icon: pinLocationIcon!));
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), AppAssets.location_png);
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        // startAddressController.text = _currentAddress;
        // _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  ConcreteCoreRemoteDataSource remoteDataSource =
      ConcreteCoreRemoteDataSource();

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
    if (_permissionStatus.isGranted) {
      await _getCurrentLocation();
    } else {
      requestPermission(_permission);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
    if (_permissionStatus.isGranted) {
      await _getCurrentLocation();
    }
  }

  ///===========================================================================

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
        Translations.of(context).translate('order_details'),
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
        key: _scaffoldKey,
        body: FutureBuilder(
          future: fetchOrderDetailsOnline(args.id, _cancelToken),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              OrderDetailsOnline details = snapshot.data as OrderDetailsOnline;
              print(
                  'details online is ***************************************** $details');
              return Container(
                  height: height,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: Column(
                            children: [
                          _buildOrderInfoWidget(
                            context: context,
                            name: details.result.paymentMehtod,
                            height: height,
                            width: width,
                            price: args.subtotal.toString(),
                            orderNumber: args.uid,
                          ),
                          VerticalPadding(
                            percentage: 2.0,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: EdgeMargin.min, right: EdgeMargin.min),
                            child: _buildMap(
                              width: width,
                              height: height,
                              context: context,
                            ),
                          ),
                          VerticalPadding(
                            percentage: 2.0,
                          ),
                          _buildPaymentMethodWidget(
                              width: width,
                              height: height,
                              context: context,
                              name: details.result.methodId == 1
                                  ? 'دفع الكتروني'
                                  : 'دفع عند التوصيل'),
                          _orderStatus(
                              width: width,
                              height: height,
                              context: context,
                              status: details.result.status),
                          _orderDate(
                              width: width,
                              height: height,
                              context: context,
                              date: details.result.order_date ?? ''),
                          VerticalPadding(
                            percentage: 2.0,
                          ),
                          Table(border: TableBorder.all(), columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          }, children: [
                            TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                children: [
                                  Text("مقاس اليد"),
                                  Text('مقاس ابط'),
                                  Text("الكوع"),
                                  Text('مقاس جيبزور'),
                                ]),
                            TableRow(children: [
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.hand.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.armpit.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.elbow.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.gypsour.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                            ]),
                            TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                children: [
                                  Text('الخطوات'),
                                  Text('نوع اليد'),
                                  Text('نوع التفصيل'),
                                  Text('الاضافات'),
                                ]),
                            TableRow(children: [
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.step.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      details.result.typeHand.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.tailor.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      details.result.addition.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                            ]),
                            TableRow(
                                decoration:
                                    BoxDecoration(color: Colors.grey[300]),
                                children: [
                                  Text('نوع اللياقة'),
                                  Text('مقاس الرقبة'),
                                  Text('نوع الحشوة'),
                                  Text('نوع الجيبزور'),
                                ]),
                            TableRow(children: [
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.collar.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(details.result.neck.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      details.result.gypsourtype.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                      details.result.fillingtype.toString(),
                                      style: TextStyle(
                                          fontSize: details.result.collar
                                                      .toString()
                                                      .length >
                                                  6
                                              ? 10
                                              : 14))),
                            ]),
                          ]),
                          SizedBox(
                            height: 30,
                          ),
                          _buildPriceSummeryWidget(
                              width: width,
                              height: height,
                              context: context,
                              order: details),
                        ]),
                      ),
                    ),
                  ));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child:
                    Text(Translations.of(context).translate('err_connection')),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  _buildRowWidget(title, description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(description)],
    );
  }

  _getCount(List<OrderItemEntity> list) {
    int count = 0;
    if (list != null && list.isNotEmpty) {
      for (OrderItemEntity item in list) {
        if (item.quantity != null && item.quantity != 0) {
          count += item.quantity!;
        }
      }
    }
    return count;
  }

  _buildPriceSummeryWidget({
    required BuildContext context,
    required double width,
    required double height,
    OrderDetailsOnline? order,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Translations.of(context).translate('price'),
            style: textStyle.smallTSBasic.copyWith(
                color: globalColor.black, fontWeight: FontWeight.bold),
          ),
          _buildPriceItem(
            width: width,
            height: height,
            context: context,
            title: Translations.of(context).translate('tailor_value'),
            value: order!.result.subtotal.toString(),
          ),
          SizedBox(
            height: 5,
          ),
          _buildPriceItem(
            width: width,
            height: height,
            context: context,
            title: Translations.of(context).translate('order_delivery_fee'),
            value: order.result.deliveryFee.toString(),
          ),
          SizedBox(
            height: 5,
          ),
          _buildPriceItem(
            width: width,
            height: height,
            context: context,
            title: Translations.of(context).translate('order_discount'),
            value: order.result.discount.toString(),
          ),
          SizedBox(
            height: 5,
          ),

          _buildPriceItem(
              width: width,
              height: height,
              context: context,
              title: Translations.of(context).translate('tax'),
              value: order.result.tax.toString()),
          _buildPriceItem(
              width: width,
              height: height,
              context: context,
              title: Translations.of(context).translate('order_total'),
              value: ((order.result.subtotal + order.result.deliveryFee) -
                  order.result.discount)
                  .toString()),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  _buildPriceItem(
      {required BuildContext context,
      required double width,
      required double height,
      String? title,
      String? value}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          EdgeMargin.min,
          EdgeMargin.min,
          EdgeMargin.min,
          EdgeMargin.min,
        ),
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: textStyle.smallTSBasic.copyWith(color: globalColor.black),
            ),
            HorizontalPadding(
              percentage: 3.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value ?? '',
                  style: textStyle.smallTSBasic.copyWith(
                      color: globalColor.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '${Translations.of(context).translate('rail')}',
                  style: textStyle.smallTSBasic
                      .copyWith(color: globalColor.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildOrderInfoWidget({
    required BuildContext context,
    required double width,
    required double height,
    required String? name,
    required String? orderNumber,
    required String? price,
    // String date
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            EdgeMargin.verySub,
            0,
            EdgeMargin.verySub,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,

          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: globalColor.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.0,
                                      color: globalColor.primaryColor)),
                              child: Icon(
                                Icons.check,
                                color: globalColor.white,
                                size: 10,
                              ),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              name ?? '',
                              style: textStyle.middleTSBasic.copyWith(
                                  color: globalColor.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              Translations.of(context).translate('order_no') +
                                  ':',
                              style: textStyle.minTSBasic
                                  .copyWith(color: globalColor.black),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              orderNumber ?? '',
                              style: textStyle.minTSBasic
                                  .copyWith(color: globalColor.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1.0,
                color: globalColor.grey.withOpacity(0.3),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  alignment: AlignmentDirectional.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Text(
                        price ?? '',
                        style: textStyle.bigTSBasic.copyWith(
                            color: globalColor.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Text(
                        '${Translations.of(context).translate('rail')}',
                        style: textStyle.middleTSBasic
                            .copyWith(color: globalColor.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildMap({
    required BuildContext context,
    required double width,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        width: width,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalPadding(
              percentage: 0.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Translations.of(context)
                              .translate('cart_txt_delivery_location'),
                          style: textStyle.smallTSBasic.copyWith(
                              color: globalColor.black,
                              fontWeight: FontWeight.bold),
                        ),
                        HorizontalPadding(
                          percentage: 1.0,
                        ),
                        // Text(
                        //   Translations.of(context)
                        //       .translate('cart_txt_automatic_GPS_selections'),
                        //   style: textStyle.smallTSBasic.copyWith(
                        //       color: globalColor.primaryColor,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Icon(
                    utils.getLang() != 'ar'
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_left,
                    color: globalColor.black,
                  ),
                ),
              ],
            ),
            //  _buildSearchWidgetForMap(context: context, width: width),
            Container(
                height: 50,
                padding: const EdgeInsets.all(EdgeMargin.small),
                child: Text('- ${args.address}',
                    style: textStyle.smallTSBasic.copyWith(
                        color: globalColor.black, fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }

  _buildPaymentMethodWidget({
    required BuildContext context,
    required double width,
    required double height,
    String? name,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            EdgeMargin.min,
            EdgeMargin.min,
            EdgeMargin.min,
            EdgeMargin.min,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,

          child: Row(
            children: [
              Text(
                Translations.of(context).translate('payment_method'),
                style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
              ),
              HorizontalPadding(
                percentage: 3.0,
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: globalColor.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1.0,
                                      color: globalColor.primaryColor)),
                              child: Icon(
                                Icons.check,
                                color: globalColor.white,
                                size: 10,
                              ),
                            ),
                            HorizontalPadding(
                              percentage: 1.0,
                            ),
                            Text(
                              name ?? '',
                              style: textStyle.middleTSBasic.copyWith(
                                  color: globalColor.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _orderDate({
    required BuildContext context,
    required double width,
    required double height,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      height: 41,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            0,
            0,
            0,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: EdgeMargin.subMin, right: EdgeMargin.subMin),
                    child: Text(
                      '${Translations.of(context).translate('date')}',
                      style: textStyle.smallTSBasic.copyWith(
                          color: globalColor.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  //margin: const EdgeInsets.only(left:EdgeMargin.min,right: EdgeMargin.min),
                  width: 148,
                  height: 41,
                  color: globalColor.scaffoldBackGroundGreyColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // color: _getColorStatus(
                            //     context: context, status: status) ??
                            //     globalColor.green,
                            // shape: BoxShape.circle,
                            border: Border.all(
                                color: globalColor.grey.withOpacity(0.2),
                                width: 1.0)),
                        width: 12,
                        height: 12,
                      ),
                      HorizontalPadding(
                        percentage: 1,
                      ),
                      Text(
                        //'${Translations.of(context).translate('delivery_stage')}',
                        date,
                        style: textStyle.minTSBasic
                            .copyWith(color: globalColor.primaryColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _orderStatus({
    required BuildContext context,
    required double width,
    required double height,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        EdgeMargin.subMin,
        EdgeMargin.verySub,
        EdgeMargin.subMin,
        EdgeMargin.verySub,
      ),
      height: 41,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            0,
            0,
            0,
          ),
          decoration: BoxDecoration(
            color: globalColor.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
                color: globalColor.grey.withOpacity(0.3), width: 0.5),
          ),
          //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: EdgeMargin.subMin, right: EdgeMargin.subMin),
                    child: Text(
                      '${Translations.of(context).translate('order_status')}',
                      style: textStyle.smallTSBasic.copyWith(
                          color: globalColor.black,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  //margin: const EdgeInsets.only(left:EdgeMargin.min,right: EdgeMargin.min),
                  width: 148,
                  height: 41,
                  color: globalColor.scaffoldBackGroundGreyColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: _getColorStatus(
                                    context: context, status: status) ??
                                globalColor.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: globalColor.grey.withOpacity(0.2),
                                width: 1.0)),
                        width: 12,
                        height: 12,
                      ),
                      HorizontalPadding(
                        percentage: 1,
                      ),
                      Text(
                        //'${Translations.of(context).translate('delivery_stage')}',
                        _getStrStatus(context: context, status: status),
                        style: textStyle.minTSBasic
                            .copyWith(color: globalColor.primaryColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customCurt(title, description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              title.toString(),
              style: textStyle.minTSBasic.copyWith(color: globalColor.black),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              height: 35,
              width: 2,
              color: Colors.grey,
            ),
            Text("     "),
            Expanded(
                child: Text(
              description.toString(),
              style: textStyle.minTSBasic.copyWith(color: globalColor.black),
            )),
          ],
        ),
      ),
    );
  }

  Future<OrderDetailsOnline?> fetchOrderDetailsOnline(orderId,
      [cancelToken]) async {
    // print(orderId);
    final Map<String, dynamic> headers = {};

    // Get the language.
    final lang = await appConfig.currentLanguage;

    headers.putIfAbsent(HEADER_LANGUAGE, () => lang);
    headers.putIfAbsent(HEADER_CONTENT_TYPE, () => 'application/json');
    headers.putIfAbsent(HEADER_ACCEPT, () => 'application/json');
    final token = await UserRepository.authToken;

    // headers.putIfAbsent(HEADER_AUTH, () => 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjkzYmY5OTNkYzQwZTE4OTY0ZjgzODFkZDU3NmQ4MjU0YTc2YjNhMzMxMGJiYWQxNTA3Y2Y0NzJmNTJhY2VjNzFkNWE2YjM0Y2ViMTM5NmQ0In0.eyJhdWQiOiIyIiwianRpIjoiOTNiZjk5M2RjNDBlMTg5NjRmODM4MWRkNTc2ZDgyNTRhNzZiM2EzMzEwYmJhZDE1MDdjZjQ3MmY1MmFjZWM3MWQ1YTZiMzRjZWIxMzk2ZDQiLCJpYXQiOjE2MzEzOTE5OTksIm5iZiI6MTYzMTM5MTk5OSwiZXhwIjoxNjYyOTI3OTk5LCJzdWIiOiIyNSIsInNjb3BlcyI6W119.Uj9F_OLp2hEGOMOCz9QKSjaQCBbjz_D0nxWcwP27lVqb8VHMO5dO9mrGWIIAlX0ogDAe0Ok0RVxiKtTbOHgc4h9gs3J-fsX44mfBSnguXlAxG61Y0Dv8IdK4gCVInGdpGbLmaNhGdERKQA0yfrtDDN21uwcq847Ak7QxeLYGp-Z2LDSgtfs1GihsjVHlyPnGA9tTDQ_CiEn6Cc3L5JiOebioK9HGRpwyt2IxKFw3IyQlBqFYSFYbQm_yUM5uVY6PpPl4pUO_uf5O87VsaUOQyVTWwQ_zqonrhe2IcZxn_XjP7peUjFUyOhR0T5pPwRYs0x6r1IQlDHKADX5Q2GIIGHybcLCCM-AgwQcb6vNB4LvUKxZmDL3Nq1izsrLh00PR7ZAxI5LE_CIHscB12o1929mN_3XrpZT0JE0wI6WFh9jFBjeQ__FaBu48E9JqFtB94GRloca4Xve_YCfN7uhHFrUu8a9QGI39ODKH41sfxTk5h1hGVkYcBEdTrr0Ypd8YEsCgIwOQUqJ1mO7RBllRVbO_HF3qHjonH9_ZCYTKFzI3nUqs3LT_Q0PjOOtsM_65a4zIeAmoPy8U8GjCpXcgi97VW_cL786FFRTId5PXbmSav0MA_Da3RntfnJDaGl2uT69RGPesTZ4YpoJigR3QZSYVZCJPiRT9b4DL2CKwap4');

    headers.putIfAbsent(HEADER_AUTH, () => 'Bearer $token');

    Response response = await Dio().get(
      getOrderDetailsOnline(orderId),
      options: Options(headers: headers),
    );
    print("that is response statusCode" + " " + response.statusCode.toString());

    print(response.data);
    try {
      if (response.statusCode == 200) {
        return OrderDetailsOnline.fromJson(response.data);
      }
    } catch (e) {
      print(
          "catch error ====================================***************** $e");
      throw "يرجي لمحاولة لاحقا";
      return OrderDetailsOnline.fromJson({});
    }
  }

  _getStrStatus({required BuildContext context, required String status}) {
    switch (status) {
      case "pending":
        return Translations.of(context).translate('take_measurements');
        break;
      case "accepted":
        return Translations.of(context).translate('Bill');
        break;
      case "shipped":
        return Translations.of(context).translate('Underway');

      case "completed":
        return Translations.of(context).translate('charged');
      default:
        return Translations.of(context).translate('take_measurements');
        break;
    }
  }

  _getColorStatus({required BuildContext context, required String status}) {
    switch (status) {
      case "accepted":
        return globalColor.green;
        break;
      case "canceled":
        return globalColor.red;
        break;

      case "pending":
        return globalColor.buttonColorOrange;
        break;
      default:
        return globalColor.green;
        break;
    }
  }

// Future<OrderDetailsOnline>? fetchOrderDetailsOnline(
//     int id, CancelToken cancelToken) async {
//   appSharedPrefs.init();
//   String token = appSharedPrefs.getToken();
//
//   Response response = Dio().get(
//     getOrderDetailsOnline(id),
//     options: Options(headers: {'Authorization': 'Bearer $token'}),
//     cancelToken: cancelToken,
//   ) as Response;
//
//   if (response.statusCode == 200) {
//     return OrderDetailsOnline.fromJson(response.data);
//   } else {
//     return OrderDetailsOnline.fromJson({});
//   }
// }
}

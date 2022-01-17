import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ojos_app/core/appConfig.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_state.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/entities/shipping_carriers_entity.dart';
import 'package:ojos_app/core/errors/connection_error.dart';
import 'package:ojos_app/core/errors/custom_error.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/params/no_params.dart';
import 'package:ojos_app/core/providers/cart_provider.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/widget/button/custom2_dropdown_button.dart';
import 'package:ojos_app/core/ui/widget/button/rounded_button.dart';
import 'package:ojos_app/core/ui/widget/general_widgets/error_widgets.dart';
import 'package:ojos_app/core/ui/widget/text/normal_form_field.dart';
import 'package:ojos_app/core/usecases/get_cities.dart';
import 'package:ojos_app/core/usecases/get_shipping_carriers.dart';
import 'package:ojos_app/core/validators/base_validator.dart';
import 'package:ojos_app/core/validators/required_validator.dart';
import 'package:ojos_app/features/cart/data/models/attrbut_cmodel.dart';
import 'package:ojos_app/features/cart/data/models/delevary_to.dart';
import 'package:ojos_app/features/cart/data/repositories/negabor_rebo.dart';
import 'package:ojos_app/features/cart/domin/entities/coupon_code_entity.dart';
import 'package:ojos_app/features/cart/domin/services/cart_api.dart';
import 'package:ojos_app/features/cart/presentation/args/cart_page_gahez_args.dart';
import 'package:ojos_app/features/cart/presentation/args/cart_page_tafsil_args.dart';
import 'package:ojos_app/features/cart/presentation/args/check_and_pay_args.dart';
import 'package:ojos_app/features/cart/presentation/blocs/coupon_bloc.dart';
import 'package:ojos_app/features/cart/presentation/widgets/item_product_cart_widget.dart';
import 'package:ojos_app/features/order/domain/entities/city_order_entity.dart';
import 'package:ojos_app/features/others/data/models/about_app_result_model.dart';
import 'package:ojos_app/features/others/domain/entity/about_app_result.dart';
import 'package:ojos_app/features/others/domain/usecases/get_about_app.dart';
import 'package:ojos_app/features/user_management/presentation/widgets/user_management_text_field_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart' as Get;
import '../../../../main.dart';
import 'enter_cart_info_page.dart';
import 'package:ojos_app/xternal_lib/model_progress_hud.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  static const routeName = '/cart/pages/CartPage';
  final TabController? tabController;

  const CartPage({this.tabController});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //var parameters = Get.Get.parameters;

  // var args = Get.Get.arguments as CartPageGahezArgs;

  /// frame Height parameters
  bool _copontValidation = false;
  String _copon = '';
  TextEditingController? coponEditingController;
  final CartApi cartApi = CartApi();

  /// phone parameters
  bool _phoneValidation = false;
  String _phone = '';
  final TextEditingController phoneEditingController =
      new TextEditingController();

  final TextEditingController regionController = new TextEditingController();

  final TextEditingController flatController = new TextEditingController();

  final TextEditingController streetController = new TextEditingController();

  final TextEditingController nameController = new TextEditingController();

  bool mosqueNameValidation = false;
  String mosqueName = '';
  final TextEditingController mosqueEditingController =
      new TextEditingController();

  bool recipientnumberValidation = false;
  String recipientnumberName = '';
  final TextEditingController workerEditingController =
      new TextEditingController();

  late ShippingCarriersEntity _shippingCarriers; //null
  CityOrderEntity _city = CityOrderEntity(
    id: -1,
    name: 'city',
    shiping_time: '0',
    status: false,
  );
  SettingsAppResult settings = SettingsAppResult(
      default_tax: null,
      default_currency: 'rial',
      google_maps_key: 'pp',
      fee_delivery: '25');
  late var negaboor;

  late List<ShippingCarriersEntity> _listOfShippingCarriers;
  List<CityOrderEntity> _listOfCities = [];

  late List<ShippingCarriersEntity> _listOfPaymentMethods;
  ShippingCarriersEntity _paymentMethods = ShippingCarriersEntity(
    id: 2,
    name: '',
  ); //n

  CustomDrobDowenField? deliveryTo;
  List<CustomDrobDowenField> deliveryList = [
    CustomDrobDowenField(ar: "مسجد", en: "mosque", key: "mosque"),
    CustomDrobDowenField(ar: "المنزل", en: "home", key: "home"),
    CustomDrobDowenField(ar: "العمل", en: "work", key: "work"),
    CustomDrobDowenField(ar: "استراحة", en: "reset", key: "rest"),
  ];
  GlobalKey<DropdownSearchState> _fbKey = GlobalKey();

  // Deliveryto attrbuotmodel;
  Deliveryto? prayerPlace;
  Deliveryto? loadedAt;
  List<Deliveryto>? attrbuotmodelList;

  // List<CustomDrobDowenField>

  @override
  void initState() {
    super.initState();
    // _getShippingCarriers(0);
    _getCities(0);
    getSettings();

    bool isAuth =
        BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
            BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;

    if (isAuth == true) {
      // nameController.text =
      //     BlocProvider.of<ApplicationBloc>(context).state.userData!.name;
      // phoneEditingController.text =
      //     BlocProvider.of<ApplicationBloc>(context).state.userData!.phone;
    } else {
      nameController.text = '';
      phoneEditingController.text = '';
    }

    getNega(city_id: _city.id ?? 1);
    coponEditingController = new TextEditingController();
    _listOfShippingCarriers = [
      ShippingCarriersEntity(
        id: 0,
        name: utils.getLang() == 'ar' ? "غير محدد" : "Not Specified",
      )
    ];

    _listOfPaymentMethods = [
      ShippingCarriersEntity(
        id: 2,
        name: utils.getLang() == 'ar' ? "دفع عند الإستلام" : "Pay on receipt",
      ),
      ShippingCarriersEntity(
        id: 1,
        name: utils.getLang() == 'ar' ? "دفع الكتروني" : "Electronic payment",
      ),
    ];
    _paymentMethods = _listOfPaymentMethods[0];

    _listOfCities = [
      CityOrderEntity(
        id: 0,
        name: utils.getLang() == 'ar' ? "غير محدد" : "Not Specified",
      )
    ];

    setCustomMapPin();
    _listenForPermissionStatus();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

  ///===========================================================================

  Set<Marker> markers = {};

  /// initial position
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 13);
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
  final _formKey = GlobalKey<FormState>();

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
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

  var _couponBloc = CouponBloc();

  bool _isCouponApply = false;

  CouponCodeEntity _couponInfoSuccess = CouponCodeEntity(
      discountamount: '0',
      couponCode: '',
      total: '0',
      couponcode_type: '',
      couponId: 0,
      discount: '0',
      type: 0);

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
        Translations.of(context).translate('cart'),
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
        body: BlocListener<CouponBloc, CouponState>(
          bloc: _couponBloc,
          listener: (BuildContext context, state) async {
            if (state is CouponDoneState) {
              ErrorViewer.showCustomError(
                  context,
                  Translations.of(context)
                      .translate('discount_coupon_accepted'));
              _copon = '';
              coponEditingController!.text = '';
              _isCouponApply = true;
              _couponInfoSuccess = state.couponInfo!;
            }
            if (state is CouponFailureState) {
              final error = state.error;
              if (error is ConnectionError) {
                ErrorViewer.showCustomError(context,
                    Translations.of(context).translate('err_connection'));
              } else if (error is CustomError) {
                ErrorViewer.showCustomError(context, error.message);
              } else {
                ErrorViewer.showUnexpectedError(context);
              }
            }
          },
          child: BlocBuilder<CouponBloc, CouponState>(
              bloc: _couponBloc,
              builder: (BuildContext context, state) {
                return ModalProgressHUD(
                  inAsyncCall: state is CouponLoadingState,
                  color: globalColor.primaryColor,
                  opacity: 0.2,
                  child: Container(
                    child: Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                      if (cartProvider.getItems() != null &&
                          cartProvider.getItems()!.isNotEmpty)
                        return _city.id == -1 || settings.default_tax == null
                            ? Center(
                                child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                              ))
                            : Form(
                                key: _formKey,
                                child: Container(
                                    height: height,
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: cartProvider
                                                    .getItems()!
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return ItemProductCartWidget(
                                                    item: cartProvider
                                                        .getItems()![index],
                                                  );
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child:
                                                  _buildDimensionsInputWidget(
                                                      width: width,
                                                      height: 60.h,
                                                      context: context,
                                                      cartProvider:
                                                          cartProvider),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            _isCouponApply == true &&
                                                    _couponInfoSuccess.type == 2
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left:
                                                                EdgeMargin.min,
                                                            right:
                                                                EdgeMargin.min),
                                                    child: _buildCoponTextWidget(
                                                        width: width,
                                                        height: 50.h,
                                                        context: context,
                                                        couponInfoSuccess:
                                                            _couponInfoSuccess),
                                                  )
                                                : Container(),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: NormalOjosTextFieldWidget(
                                                controller:
                                                    phoneEditingController,
                                                maxLines: 4,
                                                filled: true,
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                        color:
                                                            globalColor.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                  EdgeMargin.small,
                                                  EdgeMargin.middle,
                                                  EdgeMargin.small,
                                                  EdgeMargin.small,
                                                ),
                                                fillColor: globalColor.white,
                                                backgroundColor:
                                                    globalColor.white,
                                                labelBackgroundColor:
                                                    globalColor.white,
                                                validator: (value) {
                                                  return BaseValidator
                                                      .validateValue(
                                                    context,
                                                    value!,
                                                    [],
                                                    _phoneValidation,
                                                  );
                                                },
                                                hintText:
                                                    Translations.of(context)
                                                        .translate(
                                                            'write_your_notes'),
                                                label: Translations.of(context)
                                                    .translate('add_notes'),
                                                keyboardType:
                                                    TextInputType.text,
                                                borderRadius: width * .02,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _phoneValidation = true;
                                                    _phone = value;
                                                  });
                                                },
                                                borderColor: globalColor.grey
                                                    .withOpacity(0.3),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: _buildpayment_methodWidget(
                                                  context: context,
                                                  width: width,
                                                  height: 50.h),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: NormalOjosTextFieldWidget(
                                                controller: nameController,
                                                maxLines: 1,
                                                filled: true,
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                        color:
                                                            globalColor.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                  EdgeMargin.small,
                                                  EdgeMargin.middle,
                                                  EdgeMargin.small,
                                                  EdgeMargin.small,
                                                ),
                                                fillColor: globalColor.white,
                                                backgroundColor:
                                                    globalColor.white,
                                                labelBackgroundColor:
                                                    globalColor.white,
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
                                                hintText:
                                                    Translations.of(context)
                                                        .translate('name'),
                                                label: Translations.of(context)
                                                    .translate('name'),
                                                keyboardType:
                                                    TextInputType.text,
                                                borderRadius: width * .02,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _phoneValidation = true;
                                                    _phone = value;
                                                  });
                                                },
                                                borderColor: globalColor.grey
                                                    .withOpacity(0.3),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: NormalOjosTextFieldWidget(
                                                controller:
                                                    phoneEditingController,
                                                maxLines: 1,
                                                filled: true,
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                        color:
                                                            globalColor.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                  EdgeMargin.small,
                                                  EdgeMargin.middle,
                                                  EdgeMargin.small,
                                                  EdgeMargin.small,
                                                ),
                                                fillColor: globalColor.white,
                                                backgroundColor:
                                                    globalColor.white,
                                                labelBackgroundColor:
                                                    globalColor.white,
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
                                                hintText:
                                                    Translations.of(context)
                                                        .translate('phone'),
                                                label: Translations.of(context)
                                                    .translate('phone'),
                                                keyboardType:
                                                    TextInputType.text,
                                                borderRadius: width * .02,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _phoneValidation = true;
                                                    _phone = value;
                                                  });
                                                },
                                                borderColor: globalColor.grey
                                                    .withOpacity(0.3),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: NormalOjosTextFieldWidget(
                                                controller: regionController,
                                                maxLines: 1,
                                                filled: true,
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                        color:
                                                            globalColor.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                  EdgeMargin.small,
                                                  EdgeMargin.middle,
                                                  EdgeMargin.small,
                                                  EdgeMargin.small,
                                                ),
                                                fillColor: globalColor.white,
                                                backgroundColor:
                                                    globalColor.white,
                                                labelBackgroundColor:
                                                    globalColor.white,
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
                                                hintText:
                                                    Translations.of(context)
                                                        .translate('region'),
                                                label: Translations.of(context)
                                                    .translate('region'),
                                                keyboardType:
                                                    TextInputType.text,
                                                borderRadius: width * .02,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _phoneValidation = true;
                                                    _phone = value;
                                                  });
                                                },
                                                borderColor: globalColor.grey
                                                    .withOpacity(0.3),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: NormalOjosTextFieldWidget(
                                                controller: streetController,
                                                maxLines: 1,
                                                filled: true,
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                        color:
                                                            globalColor.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                  EdgeMargin.small,
                                                  EdgeMargin.middle,
                                                  EdgeMargin.small,
                                                  EdgeMargin.small,
                                                ),
                                                fillColor: globalColor.white,
                                                backgroundColor:
                                                    globalColor.white,
                                                labelBackgroundColor:
                                                    globalColor.white,
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
                                                hintText:
                                                    Translations.of(context)
                                                        .translate('street'),
                                                label: Translations.of(context)
                                                    .translate('street'),
                                                keyboardType:
                                                    TextInputType.text,
                                                borderRadius: width * .02,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _phoneValidation = true;
                                                    _phone = value;
                                                  });
                                                },
                                                borderColor: globalColor.grey
                                                    .withOpacity(0.3),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: NormalOjosTextFieldWidget(
                                                controller: flatController,
                                                maxLines: 1,
                                                filled: true,
                                                style: textStyle.smallTSBasic
                                                    .copyWith(
                                                        color:
                                                            globalColor.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                  EdgeMargin.small,
                                                  EdgeMargin.middle,
                                                  EdgeMargin.small,
                                                  EdgeMargin.small,
                                                ),
                                                fillColor: globalColor.white,
                                                backgroundColor:
                                                    globalColor.white,
                                                labelBackgroundColor:
                                                    globalColor.white,
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
                                                hintText:
                                                    Translations.of(context)
                                                        .translate('flat'),
                                                label: Translations.of(context)
                                                    .translate('flat'),
                                                keyboardType:
                                                    TextInputType.text,
                                                borderRadius: width * .02,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _phoneValidation = true;
                                                    _phone = value;
                                                  });
                                                },
                                                borderColor: globalColor.grey
                                                    .withOpacity(0.3),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onFieldSubmitted: (_) {
                                                  FocusScope.of(context)
                                                      .nextFocus();
                                                },
                                              ),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            state is CouponDoneState
                                                ? SizedBox.shrink()
                                                : VerticalPadding(
                                                    percentage: 2.0,
                                                  ),
                                            /*  state is CouponDoneState
                                                ? SizedBox.shrink()
                                                : */
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: _buildPricesWidget(
                                                  width: width,
                                                  height: 50.h,
                                                  context: context,
                                                  cartProvider: cartProvider,
                                                  settings: settings),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: EdgeMargin.min,
                                                  right: EdgeMargin.min),
                                              child: _buildTotalWidget(
                                                  context: context,
                                                  width: width,
                                                  height: 50.h,
                                                  delivery_fee:
                                                      _couponInfoSuccess.type ==
                                                              2
                                                          ? 0
                                                          : int.parse(settings
                                                              .fee_delivery!),
                                                  shipping_fee:
                                                      _couponInfoSuccess.type ==
                                                              2
                                                          ? 0
                                                          : int.parse(settings
                                                              .fee_delivery!),
                                                  cartProvider: cartProvider),
                                            ),
                                            VerticalPadding(
                                              percentage: 2.0,
                                            ),
                                            Container(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                padding: const EdgeInsets.only(
                                                    left: EdgeMargin.min,
                                                    right: EdgeMargin.min),
                                                child: Text(
                                                  '${Translations.of(context).translate('txt_cart_desc')} \n ${Translations.of(context).translate('the_number_of_products')} ${cartProvider.getItemsCount().toString()}',
                                                  style: textStyle.smallTSBasic
                                                      .copyWith(
                                                          color:
                                                              globalColor.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                )),
                                            VerticalPadding(
                                              percentage: 4.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                      return Container(
                        height: height,
                        width: width,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${Translations.of(context).translate('the_basket_is_empty')}',
                                style: textStyle.smallTSBasic
                                    .copyWith(color: globalColor.primaryColor),
                              ),
                              VerticalPadding(
                                percentage: 4.0,
                              ),
                              Container(
                                width: width,
                                margin:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: RoundedButton(
                                  height: 55.h,
                                  width: width * 5,
                                  color: globalColor.primaryColor,
                                  onPressed: () {
                                    if (widget.tabController != null) {
                                      widget.tabController!.animateTo(0);
                                    } else {
                                      Get.Get.back();
                                    }
                                  },
                                  borderRadius: 8.w,
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        Translations.of(context)
                                            .translate('shop_now'),
                                        style: textStyle.middleTSBasic
                                            .copyWith(color: globalColor.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
        ));
  }

  _buildDimensionsInputWidget(
      {required BuildContext context,
      required double width,
      required double height,
      required CartProvider cartProvider
      // TextEditingController controller,
      // bool textValidation,
      // String text,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      height: height,
      width: width,

      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: globalColor.white.withOpacity(0.5),
                    borderRadius: BorderRadius.all(Radius.circular(12.w)),
                    border: Border.all(
                        color: globalColor.grey.withOpacity(0.3), width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                      EdgeMargin.subMin,
                      EdgeMargin.verySub,
                    ),
                    child: Text(
                      Translations.of(context).translate('discount_coupon'),
                      style: textStyle.middleTSBasic
                          .copyWith(color: globalColor.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1.0,
            color: globalColor.grey.withOpacity(0.3),
          ),
          Expanded(
            flex: 6,
            child: Container(
              child: BorderFormField(
                controller: coponEditingController!,
                validator: (value) {
                  return BaseValidator.validateValue(
                    context,
                    value!,
                    [],
                    _copontValidation,
                  );
                },
                hintText: '- - - - -',
                hintStyle: textStyle.smallTSBasic.copyWith(
                    color: globalColor.grey, fontWeight: FontWeight.bold),
                style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.black, fontWeight: FontWeight.bold),
                filled: false,
                keyboardType: TextInputType.text,
                borderRadius: 12.w,
                onSaved: (String? value) {
                  _copon = value!;
                  if (value.isNotEmpty) {
                    _couponBloc.add(ApplyCouponEvent(
                        cancelToken: _cancelToken,
                        couponCode: _copon,
                        total: cartProvider
                            .getTotalPricesint()
                            .toStringAsFixed(2)));
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _copontValidation = true;
                    _copon = value;
                  });
                  /*    if (value.isNotEmpty && value.length == 4) {
                    _couponBloc.add(ApplyCouponEvent(
                        cancelToken: _cancelToken,
                        couponCode: _copon,
                        total: cartProvider
                            .getTotalPricesint()
                            .toStringAsFixed(2)));
                    // _applyCoupon(
                    //     couponCode: _copon,
                    //     total:
                    //         cartProvider.getTotalPrices().toStringAsFixed(2));
                  }*/
                },
                textAlign: TextAlign.center,
                borderColor: globalColor.transparent,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                  _couponBloc.add(ApplyCouponEvent(
                      cancelToken: _cancelToken,
                      couponCode: _copon,
                      total:
                          cartProvider.getTotalPricesint().toStringAsFixed(2)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCoponTextWidget({
    required BuildContext context,
    required double width,
    required double height,
    required CouponCodeEntity couponInfoSuccess,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        // border:
        // Border.all(color: globalColor.primaryColor.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      height: height,
      width: width,

      child: Wrap(
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
                color: globalColor.white,
                borderRadius: BorderRadius.circular(12.0.w),
                border: Border.all(
                    color: globalColor.grey.withOpacity(0.3), width: 0.5)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(EdgeMargin.sub, EdgeMargin.sub,
                  EdgeMargin.sub, EdgeMargin.sub),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 1.w,
                  ),
                  SvgPicture.asset(
                    AppAssets.sales_svg,
                    width: 10.w,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  // Text(
                  //   '${couponInfoSuccess.discountAmount ?? ''}',
                  //   style: textStyle.minTSBasic.copyWith(
                  //       color: globalColor.primaryColor,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Text(
                    Translations.of(context).translate('Delivery_free'),
                    style: textStyle.smallTSBasic.copyWith(
                        color: globalColor.goldColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Text(
          //   Translations.of(context).translate('discounted'),
          //   style: textStyle.middleTSBasic.copyWith(
          //       color: globalColor.white, fontWeight: FontWeight.bold),
          // ),
          // Text(
          //   '${couponInfoSuccess.discount ?? ''}',
          //   style: textStyle.bigTSBasic.copyWith(
          //       color: globalColor.goldColor, fontWeight: FontWeight.bold),
          // ),
          // Text(
          //   '${Translations.of(context).translate('rail')} ${Translations.of(context).translate('from_code')} ',
          //   style: textStyle.middleTSBasic.copyWith(
          //       color: globalColor.white, fontWeight: FontWeight.bold),
          // ),
          // Text(
          //   '${couponInfoSuccess.couponCode ?? ''}',
          //   style: textStyle.bigTSBasic.copyWith(
          //       color: globalColor.goldColor, fontWeight: FontWeight.bold),
          // ),
        ],
      ),
    );
  }

  _buildPricesWidget(
      {required BuildContext context,
      required double width,
      required double height,
      required CartProvider cartProvider,
      required SettingsAppResult settings}) {
    var discount;
    if (_isCouponApply == true && _couponInfoSuccess.type == 1) {
      discount = cartProvider.getTotalPricesAfterDiscount() -
          int.parse(_couponInfoSuccess.discount!);
    } else {
      discount = cartProvider.getTotalPricesAfterDiscount();
    }
    return Container(
      width: width,
      child: Column(
        children: [
          _buildPricesInfoItem(
              height: height,
              width: width,
              value: cartProvider.getTotalPricesint().toString(),
              title:
                  Translations.of(context).translate('total_original_price')),
          VerticalPadding(
            percentage: 1.0,
          ),
          _buildPricesInfoItem(
              height: height,
              width: width,
              value: discount.toString(),
              title:
                  Translations.of(context).translate('price_after_discount')),
          _paymentMethods.id == 2
              ? VerticalPadding(
                  percentage: 1.0,
                )
              : SizedBox(),
          _paymentMethods.id == 2
              ? _buildPricesInfoItem(
                  height: height,
                  width: width,
                  value: settings.fee_delivery ?? '25',
                  title: Translations.of(context)
                      .translate('payment_fees_on_receipt'))
              : SizedBox(),
          VerticalPadding(
            percentage: 1.0,
          ),
          _buildPricesInfoItem(
              height: height,
              width: width,
              value: settings.fee_delivery ?? '25',
              title: Translations.of(context).translate('order_delivery_fee'))
        ],
      ),
    );
  }

  // _buildPricesWidget(
  //     {required BuildContext context,
  //     required double width,
  //     required double height,
  //     required CartProvider cartProvider}) {
  //   return Container(
  //     width: width,
  //     child: Column(
  //       children: [
  //         _buildPricesInfoItem(
  //             height: height,
  //             width: width,
  //             value: cartProvider.getTotalPricesint().toStringAsFixed(2),
  //             title:
  //                 Translations.of(context).translate('total_original_price')),
  //         VerticalPadding(
  //           percentage: 1.0,
  //         ),
  //         _paymentMethods != null &&
  //                 _paymentMethods.id != null &&
  //                 _paymentMethods.id == 2
  //             ? _buildPricesInfoItem(
  //                 height: height,
  //                 width: width,
  //                 value: '25',
  //                 title: Translations.of(context)
  //                     .translate('payment_fees_on_receipt'))
  //             : Container(),
  //       ],
  //     ),
  //   );
  // }

  _buildPricesInfoItem({
    required double height,
    required double width,
    required String? title,
    required String? value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        // border:
        // Border.all(color: globalColor.primaryColor.withOpacity(0.3), width: 0.5),
      ),
      padding: const EdgeInsets.only(
        left: EdgeMargin.sub,
        right: EdgeMargin.sub,
      ),
      height: height,
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title ?? '',
              style: textStyle.smallTSBasic.copyWith(color: globalColor.black),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value ?? '',
                  style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.goldColor,
                  ),
                ),
                Text(
                  '${Translations.of(context).translate('rail')}',
                  style: textStyle.smallTSBasic.copyWith(
                    color: globalColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildpayment_methodWidget({
    required BuildContext context,
    required double width,
    required double height,
    TextEditingController? controller,
    bool? textValidation,
    String? text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      height: height,
      width: width,

      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                ),
                child: Text(
                  Translations.of(context).translate('payment_method'),
                  style:
                      textStyle.smallTSBasic.copyWith(color: globalColor.black),
                ),
              ),
            ),
          ),
          Container(
            width: 1.0,
            color: globalColor.grey.withOpacity(0.3),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                EdgeMargin.subMin,
                EdgeMargin.verySub,
                EdgeMargin.subMin,
                EdgeMargin.verySub,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      // width: widget.width * .4,
                      height: 35.h,
                      child: Custom2Dropdown<ShippingCarriersEntity>(
                        onChanged: (data) {
                          _paymentMethods = data!;
                          print(_paymentMethods.id);
                          if (mounted) setState(() {});
                        },
                        value: _paymentMethods,
                        borderRadius: 0,
                        hint: '',
                        dropdownMenuItemList:
                            _listOfPaymentMethods.map((profession) {
                          return DropdownMenuItem(
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  color: profession == _paymentMethods
                                      ? globalColor.primaryColor
                                          .withOpacity(0.3)
                                      : globalColor.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.w))),
                              padding: EdgeInsets.all(EdgeMargin.small),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    profession.name ?? '',
                                    style: textStyle.smallTSBasic.copyWith(
                                        color: globalColor.primaryColor),
                                  ),
                                ),
                                alignment: AlignmentDirectional.center,
                              ),
                            ),
                            value: profession,
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return _listOfPaymentMethods.map<Widget>((item) {
                            return Center(
                              child: Text(
                                item.name ?? '',
                                style: textStyle.smallTSBasic
                                    .copyWith(color: globalColor.primaryColor),
                              ),
                            );
                          }).toList();
                        },
                        isEnabled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildSelectCitiesWidget({
    required BuildContext context,
    required double width,
    required double height,
    TextEditingController? controller,
    bool? textValidation,
    String? text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      height: height,
      width: width,

      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                ),
                child: Text(
                  Translations.of(context).translate('choose_a_city'),
                  style:
                      textStyle.smallTSBasic.copyWith(color: globalColor.black),
                ),
              ),
            ),
          ),
          // Container(
          //   width: 1.0,
          //   color: globalColor.grey.withOpacity(0.3),
          // ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     padding: const EdgeInsets.fromLTRB(
          //       EdgeMargin.subMin,
          //       EdgeMargin.verySub,
          //       EdgeMargin.subMin,
          //       EdgeMargin.verySub,
          //     ),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Expanded(
          //           child: Container(
          //             // width: widget.width * .4,
          //             height: 35.h,
          //             // child: Custom2Dropdown<CityOrderEntity>(
          //             //   onChanged: (data) {
          //             //     getNega(city_id: data!.id);
          //             //     _city = data;
          //             //     if (mounted) setState(() {});
          //             //     print(data.id!);
          //             //   },
          //             //   value: _city,
          //             //   borderRadius: 0,
          //             //   hint: '',
          //             //   dropdownMenuItemList: _listOfCities.map((profession) {
          //             //     return DropdownMenuItem(
          //             //       child: Container(
          //             //         width: width,
          //             //         decoration: BoxDecoration(
          //             //             color: profession == _city
          //             //                 ? globalColor.primaryColor
          //             //                     .withOpacity(0.3)
          //             //                 : globalColor.white,
          //             //             borderRadius:
          //             //                 BorderRadius.all(Radius.circular(12.w))),
          //             //         padding: EdgeInsets.all(EdgeMargin.small),
          //             //         child: Container(
          //             //           child: Center(
          //             //             child: Text(
          //             //               profession.name ?? '',
          //             //               style: textStyle.smallTSBasic.copyWith(
          //             //                   color: globalColor.primaryColor),
          //             //             ),
          //             //           ),
          //             //           alignment: AlignmentDirectional.center,
          //             //         ),
          //             //       ),
          //             //       value: profession,
          //             //     );
          //             //   }).toList(),
          //             //   selectedItemBuilder: (BuildContext context) {
          //             //     return _listOfCities.map<Widget>((item) {
          //             //       return Center(
          //             //         child: Text(
          //             //           item.name ?? '',
          //             //           style: textStyle.smallTSBasic
          //             //               .copyWith(color: globalColor.primaryColor),
          //             //         ),
          //             //       );
          //             //     }).toList();
          //             //   },
          //             //   isEnabled: true,
          //             // ),
          //             child: TextField(),
          //           ),
          //         ),
          //         // Expanded(
          //         //   child: Container(
          //         //     child: Text(
          //         //       'ارامكس',
          //         //       style: textStyle.smallTSBasic
          //         //           .copyWith(color: globalColor.primaryColor),
          //         //     ),
          //         //     alignment: AlignmentDirectional.center,
          //         //   ),
          //         // ),
          //         // Container(
          //         //   child: Icon(
          //         //     MaterialIcons.keyboard_arrow_down,
          //         //     color: globalColor.black,
          //         //   ),
          //         // ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _buildTotalWidget(
      {required BuildContext context,
      double? width,
      double? height,
      required int delivery_fee,
      required int shipping_fee,
      TextEditingController? controller,
      bool? textValidation,
      String? text,
      CartProvider? cartProvider}) {
    int discount = 0;

    if (_isCouponApply == true && _couponInfoSuccess.type == 1) {
      discount = cartProvider!.getTotalPricesAfterDiscount() -
          int.parse(_couponInfoSuccess.discount!);
    } else {
      discount = cartProvider!.getTotalPricesAfterDiscount();
    }
    int finalPrice = 0;

    if (_paymentMethods.id == 2) {
      finalPrice = discount + delivery_fee + shipping_fee;
    } else {
      finalPrice = discount + delivery_fee;
    }

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12.w)),
      child: Container(
        decoration: BoxDecoration(
          color: globalColor.white,
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
        height: height,
        width: width,

        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
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
                        Translations.of(context).translate('final_total'),
                        style: textStyle.smallTSBasic
                            .copyWith(color: globalColor.black),
                      ),
                      HorizontalPadding(
                        percentage: 1.0,
                      ),
                      Text(
                        finalPrice.toString(),
                        style: textStyle.normalTSBasic.copyWith(
                            color: globalColor.goldColor,
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
            ),
            Container(
              width: 1.0,
              color: globalColor.grey.withOpacity(0.3),
            ),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    final String formatted = formatter.format(now);

                    int discountAmoountt = 0;

                    int priceDiscount =
                        (cartProvider.getTotalPricesAfterDiscount() -
                                cartProvider.getTotalPricesint())
                            .abs();

                    if (_isCouponApply == true &&
                        _couponInfoSuccess.type == 1) {
                      if (_couponInfoSuccess.couponcode_type == "amount") {
                        discountAmoountt = priceDiscount *
                            int.parse(_couponInfoSuccess.discountamount!) ~/
                            100;
                      } else {
                        discountAmoountt =
                            int.parse(_couponInfoSuccess.discount!);
                      }
                    } else {
                      discountAmoountt = 0;
                    }

                    Get.Get.toNamed(EnterCartInfoPage.routeName,
                        arguments: CheckAndPayArgs(
                            name: nameController.text,
                            phone: phoneEditingController.text,
                            region: regionController.text,
                            flat: flatController.text,
                            street: streetController.text,
                            date: formatted,
                            discount: discountAmoountt,
                            delivery_fee: _isCouponApply == true &&
                                    _couponInfoSuccess.type == 2
                                ? 0
                                : int.parse(settings.fee_delivery!),
                            shipping_fee:
                                _isCouponApply && _couponInfoSuccess != null
                                    ? 0
                                    : _paymentMethods != null &&
                                            _paymentMethods.id != null &&
                                            _paymentMethods.id == 2
                                        ? 0
                                        : int.parse(settings.fee_delivery!),
                            address:
                                '${regionController.text} , ${streetController.text} , ${flatController.text}',
                            listOfOrder: cartProvider.listOfCart,
                            total: 0,
                            city_id: _city.id!,
                            coupon_id: 0,
                            couponcode: _copon,
                            note: /* appConfig.notNullOrEmpty()
                                ? _phone
                                :*/
                                Translations.of(context)
                                    .translate('there_is_no'),
                            orginal_price: 0,
                            price_discount: priceDiscount,
                            point_map: _city.name!,
                            paymentMethods: _paymentMethods.id!,
                            tax: int.parse(settings.default_tax!),
                            totalPrice: '0',
                            load_id: loadedAt?.id ?? 110,
                            dest_name: mosqueName,
                            guard_number: recipientnumberName,
                            dest_type: prayerPlace?.id ?? 0,
                            delivery_to: '',
                            shipping_id: 0,
                            neighborhood_id: 0));
                  }
                },
                child: Container(
                  color: globalColor.primaryColor,
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: FittedBox(
                            child: Text(
                              Translations.of(context).translate(
                                  'adoption_of_the_basket_and_payment'),
                              style: textStyle.smallTSBasic
                                  .copyWith(color: globalColor.white),
                            ),
                          ),
                          alignment: AlignmentDirectional.center,
                        ),
                      ),
                      Container(
                        child: Icon(
                          utils.getLang() != 'ar'
                              ? Icons.keyboard_arrow_right
                              : Icons.keyboard_arrow_left,
                          color: globalColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _finalTotalPrice({cartProvider}) {
  //   return _isCouponApply && _couponInfoSuccess != null
  //       ? (_couponInfoSuccess.total!.toDouble() +
  //               (_paymentMethods != null &&
  //                       _paymentMethods.id != null &&
  //                       _paymentMethods.id == 2
  //                   ? 25
  //                   : 0))
  //           .toStringAsFixed(2)
  //       : (cartProvider.getTotalPricesint() +
  //               (_paymentMethods != null &&
  //                       _paymentMethods.id != null &&
  //                       _paymentMethods.id == 2
  //                   ? 25
  //                   : 0))
  //           .toStringAsFixed(2);
  // }

  int _finalTotalPriceint({cartProvider}) {
    double p = 0;
    p = (cartProvider.getTotalPricesint() +
        (_paymentMethods != null &&
                _paymentMethods.id != null &&
                _paymentMethods.id == 8
            ? 25
            : 0));
    return p.toInt();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _couponBloc.close();
    super.dispose();
  }

  Future<void> _getShippingCarriers(int reloadCount) async {
    int count = reloadCount;
    if (mounted) {
      final result = await GetShippingCarriers(locator<CoreRepository>())(
        NoParams(cancelToken: _cancelToken),
      );

      if (result.data != null) {
        setState(() {
          _listOfShippingCarriers = result.data!;
          if (result.data!.isNotEmpty) {
            _shippingCarriers = result.data![0];
          }
        });
      } else {
        if (count != 3)
          appConfig.check().then((internet) {
            if (internet != null && internet) {
              _getShippingCarriers(count + 1);
            }
            // No-Internet Case
          });
      }
    }
  }

  Future<void> _getCities(int reloadCount) async {
    int count = reloadCount;
    if (mounted) {
      final result = await GetCities(locator<CoreRepository>())(
        NoParams(cancelToken: _cancelToken),
      );

      if (result.data != null) {
        setState(() {
          _listOfCities = result.data!;
          if (result.data!.isNotEmpty) {
            _city = result.data![0];
          }
        });
      } else {
        if (count != 3)
          appConfig.check().then((internet) {
            if (internet != null && internet) {
              _getCities(count + 1);
            }
            // No-Internet Case
          });
      }
    }
  }

// Future<List<NegaItem>> getNega({city_id = 1})async {
//   Dio dio = Dio();
//   Response response= await dio.get(API_NEGA(city_id: city_id));
//
//
//     if (response.data != null) {
//       setState(() {
//         // _listOfnega = response.data;
//         if (response.data.isNotEmpty) {
//           // nega = response.data[0];
//         }
//       });
//     // _listOfnega=NegaModel.fromJson(response.data).result;
//     setState(() {
//
//     });
//     return NegaModel.fromJson(response.data).result;
//
//   }else{
//     throw "Cant get Data";
//   }
//
// }

// Future<void> _applyCoupon({String total, String couponCode}) async {
//   if (mounted) {
//     setState(() {
//       _sendRequest = true;
//     });
//     final result = await ApplyCouponCode(locator<CartRepository>())(
//       ApplyCouponCodeParams(
//           couponCode: couponCode, total: total, cancelToken: _cancelToken),
//     );
//
//     setState(() {
//       _sendRequest = false;
//     });
//     if (result.data != null) {
//       appConfig.showToast(
//         msg: 'done',
//       );
//     } else {
//       appConfig.showToast(msg: 'failed');
//     }
//   }
// }

  drobDowenLocal(context, Deliveryto selectedItem, itemAsString, title) =>
      Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: globalColor.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Text(
                    Translations.of(context).translate(title),
                    style: textStyle.smallTSBasic
                        .copyWith(color: globalColor.black),
                  ),
                ),
              ),
            ),
            Container(
              width: 1.0,
              color: Colors.grey.withOpacity(0.3),
            ),
            Expanded(
              child: selectedItem == null
                  ? Text(
                      utils.getLang() == 'ar' ? "غير محدد" : "Not Specified",
                      style: textStyle.smallTSBasic.copyWith(
                        color: globalColor.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Text(
                      "${selectedItem.name}",
                      style: textStyle.smallTSBasic.copyWith(
                        color: globalColor.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      );

  drobDowenNet(
          context, CustomDrobDowenField selectedItem, itemAsString, title) =>
      Container(
        height: 50.h,
        // padding: const EdgeInsets.only(
        //     // left: EdgeMargin.min,
        //     // right: EdgeMargin.min,
        // ),
        decoration: BoxDecoration(
          color: globalColor.white.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.circular(12.w)),
          border:
              Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                    EdgeMargin.subMin,
                    EdgeMargin.verySub,
                  ),
                  child: Text(
                    Translations.of(context).translate(title),
                    style: textStyle.smallTSBasic
                        .copyWith(color: globalColor.black),
                  ),
                ),
              ),
            ),
            Container(
              width: 1.0,
              color: Colors.black.withOpacity(0.3),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  selectedItem == null
                      ? Text(
                          utils.getLang() == 'ar'
                              ? "غير محدد"
                              : "Not Specified",
                          style: textStyle.middleTSBasic.copyWith(
                            color: globalColor.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          "${utils.getLang() == "ar" ? selectedItem.ar : selectedItem.en}",
                          style: textStyle.middleTSBasic.copyWith(
                            color: globalColor.primaryColor,
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      );

  drobDowenB(context, selectedItem, itemAsString, title) {
    return Container(
      height: 50.h,
      // padding: const EdgeInsets.only(
      //     // left: EdgeMargin.min,
      //     // right: EdgeMargin.min,
      // ),
      decoration: BoxDecoration(
        color: globalColor.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        border:
            Border.all(color: globalColor.grey.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                  EdgeMargin.subMin,
                  EdgeMargin.verySub,
                ),
                child: Text(
                  Translations.of(context).translate(title),
                  style:
                      textStyle.smallTSBasic.copyWith(color: globalColor.black),
                ),
              ),
            ),
          ),
          Container(
            width: 1.0,
            color: Colors.grey.withOpacity(0.3),
          ),
          Expanded(
            child: selectedItem == null
                ? Text(
                    utils.getLang() == 'ar' ? "غير محدد" : "Not Specified",
                    style: textStyle.middleTSBasic.copyWith(
                      color: globalColor.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    "$selectedItem",
                    style: textStyle.middleTSBasic.copyWith(
                      color: globalColor.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ],
      ),
    );
  }

  _buildTextField(String hint) {
    return Container(
      padding:
          const EdgeInsets.only(left: EdgeMargin.min, right: EdgeMargin.min),
      child: NormalOjosTextFieldWidget(
        controller: phoneEditingController,
        // maxLines: 4,
        filled: true,
        style: textStyle.smallTSBasic
            .copyWith(color: globalColor.black, fontWeight: FontWeight.bold),
        withShadow: true,
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
          return BaseValidator.validateValue(
            context,
            value!,
            [RequiredValidator()],
            _phoneValidation,
          );
        },
        hintText: '',
        label: Translations.of(context).translate(hint),
        keyboardType: TextInputType.phone,
        readOnly: true,
        borderRadius: MediaQuery.of(context).size.width * .02,
        onChanged: (value) {
          setState(() {
            _phoneValidation = true;
            _phone = value;
          });
        },
        prefixIcon: Container(
          width: 15.w,
          height: 15.w,
          child: Center(
            child: SvgPicture.asset(
              AppAssets.phoneSvg,
              color: globalColor.black,
              width: 15.w,
              height: 15.w,
            ),
          ),
        ),
        borderColor: globalColor.grey.withOpacity(0.3),
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
      ),
    );
  }

  Future<void> getSettings() async {
    if (mounted) {
      final result = await GetAboutApp(locator<CoreRepository>())(
        GetAboutAppParams(cancelToken: _cancelToken),
      );

      if (result.data != null) {
        setState(() {
          settings = result.data!.settings!;
          print('settings is (((((((((((((((((((((( ${settings.default_tax}');
        });
      } else {
        appConfig.check().then((internet) {
          if (internet != null && internet) {
            getSettings();
          }
          // No-Internet Case
        });
      }
    }
  }
}

String? vRequired(context, value) {
  if (value != null) {
    return null;
  } else {
    return Translations.of(context).translate('v_required');
  }
}

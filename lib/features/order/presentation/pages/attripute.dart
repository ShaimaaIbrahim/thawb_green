import 'dart:developer';

import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/providers/cart_provider.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/shared_preference_utils/shared_preferences.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/ui/dailog/add_to_cart_dialog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/features/cart/domin/entities/cart_attribute_entity.dart';
import 'package:ojos_app/features/cart/presentation/args/cart_page_tafsil_args.dart';
import 'package:ojos_app/features/cart/presentation/pages/cart_page.dart';
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/home/domain/services/home_api.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_widget.dart';
import 'package:ojos_app/features/order/data/api_responses/feach_attripute.dart';
import 'package:ojos_app/features/order/data/models/custom_order.dart';
import 'package:ojos_app/features/order/presentation/pages/confirm_attripute.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/pages/sign_in_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';

class OrderAttribute extends StatefulWidget {
  final int? price;
  final int? discountPrice;
  final String? name;
  final int? id;
  final String? image;

  const OrderAttribute(
      {Key? key, this.price, this.discountPrice, this.name, this.id, required this.image})
      : super(key: key);

  @override
  _OrderAttributeState createState() => _OrderAttributeState();
}

class _OrderAttributeState extends State<OrderAttribute> {
  // int _radioValue;
  List<Add> adds = [];
  List<TextEditingController> yakas = [];
  List<TextEditingController> gypsours = [];
  List<TextEditingController> hands = [];
  List<bool>  yaksBool= [];

  @override
  void initState() {
    hastol();
    homePageApi.feachProduct(1)!.then((value) {
      adds = value.result.adds;
    });

    super.initState();
  }

  List<bool> selectsTailors = [false, false, false, false, false];

  Future<bool> hastol() async {
    return await UserRepository.hasToken;
  }

  List<bool> marks = [false, false, false];
  TextEditingController length = TextEditingController();

  /// الرقبة
  TextEditingController neck = TextEditingController();

  /// طول اليد
  TextEditingController handLength = TextEditingController();

  /// الكتف
  TextEditingController shoulder = TextEditingController();

  ///الكوع
  TextEditingController elbow = TextEditingController();

  ///الباط
  TextEditingController bat = TextEditingController();

  ///اسفل
  TextEditingController Belowbat = TextEditingController();

  ///الخطوة
  TextEditingController step = TextEditingController();

  ///مقاس جيزور
  TextEditingController jisor = TextEditingController();

  TextEditingController waist = TextEditingController();

  TextEditingController yaka = TextEditingController();

  TextEditingController notes = TextEditingController();

  //TextEditingController yaka = TextEditingController();

  TextEditingController hand = TextEditingController();

  void generateTextFields(OrderAttributeModel attribut) {
    for (var i = 0; i < attribut.result!.collarlist!.length; i++) {
      TextEditingController controller = TextEditingController();
      yakas.add(controller);
      yaksBool.add(false);
    }
    for (var i = 0; i < attribut.result!.gypsourlist!.length; i++) {
      TextEditingController controller = TextEditingController();
      gypsours.add(controller);
    }
    for (var i = 0; i < attribut.result!.typehandlist!.length; i++) {
      TextEditingController controller = TextEditingController();
      hands.add(controller);
    }
  }

  int yakaTypeValue = 0;
  int gypsourTypeValue = 0;
  int geepTypeValue = 0;
  int handTypeValue = 0;

  int geepExcesoryTypeValue =0;
  int zraierTypeValue =0;

  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);

  final globalKey = GlobalKey<FormState>();

  HomePageApi homePageApi = HomePageApi();

  @override
  Widget build(BuildContext context) {
    /*   return UserRepository.hasToken
        ?*/
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "طلب اون لاين",
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: adds == []
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            )
          : SafeArea(
              child: FutureBuilder(
                  future: feachOrderAttribute(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      OrderAttributeModel? attribut =
                          snapshot.data as OrderAttributeModel;
                      generateTextFields(attribut);
                      return Form(
                        key: globalKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTopAds(
                                        context: context,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150.h),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Wrap(
                                      children: [
                                        customTextField("الطول", length),
                                        customTextField("الرقبة", neck),
                                        customTextField("طول اليد", handLength),
                                        customTextField("الكتف", shoulder),
                                        customTextField("الخصر", waist),
                                        customTextField("الكوع", elbow),
                                        customTextField("الباط", bat),
                                        customTextField("اسفل الباط", Belowbat),
                                        customTextField("الخطوة", step),
                                        customTextField("مقاس جبزور", jisor),
                                        // customTextField("الوسط", waist),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "نوع الياقة",
                                        style: textStyle.middleTSBasic.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 220.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () {
                                            setState(() {});
                                            yakaTypeValue = attribut
                                                .result!.collarlist![index].id!;
                                            yaka = yakas[index];
                                            yaksBool[index] = !yaksBool[index];
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                customTextWithColor(attribut
                                                        .result!
                                                        .collarlist![index]
                                                        .name ??
                                                    "", yaksBool[index]),
                                                Image.network(
                                                  attribut
                                                      .result!
                                                      .pocketslist![index]
                                                      .image!,
                                                  width: 80.w,
                                                  height: 80.h,
                                                ),
                                                onlyTextField(yakas[index],
                                                    index: 0),
                                              ],
                                            ),
                                          ),
                                        ),
                                        itemCount:
                                            attribut.result!.collarlist!.length,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "الجبزور",
                                        style: textStyle.middleTSBasic.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 220.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Image.network(
                                                  attribut
                                                      .result!
                                                      .gypsourlist![index]
                                                      .image!,
                                                  width: 80.w,
                                                  height: 80.h,
                                                ),
                                                Radio(
                                                  value: attribut.result!
                                                      .gypsourlist![index].id!,
                                                  groupValue: gypsourTypeValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      gypsourTypeValue =
                                                          value! as int;
                                                      jisor = gypsours[index];
                                                    });
                                                    print("aaaaaaaaaaaaaaaaaa" +
                                                        value.toString());
                                                  },
                                                ),
                                                onlyTextField(gypsours[index],
                                                    index: 1),
                                              ],
                                            ),
                                          ),
                                        ),
                                        itemCount: attribut
                                            .result!.fillingtype!.length,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "الجيوب",
                                        style: textStyle.middleTSBasic.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 140.h,
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 15.w),
                                      child: Row(
                                        children: [
                                          // customTextField(
                                          //     "جيب البنطلون", elbow),
                                          Expanded(
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) =>
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {});
                                                        geepTypeValue = attribut
                                                            .result!
                                                            .pocketslist![index]
                                                            .id!;
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 30.w),
                                                        child: Column(
                                                          children: [
                                                            Image.network(
                                                              attribut
                                                                  .result!
                                                                  .pocketslist![
                                                                      index]
                                                                  .image!,
                                                              width: 80.w,
                                                              height: 80.h,
                                                            ),
                                                            // Text(attribut.result.pocketslist[index].name),
                                                            Radio(
                                                              value: attribut
                                                                  .result!
                                                                  .pocketslist![
                                                                      index]
                                                                  .id!,
                                                              groupValue:
                                                                  geepTypeValue,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  geepTypeValue =
                                                                      value!
                                                                          as int;
                                                                });
                                                                print("aaaaaaaaaaaaaaaaaa" +
                                                                    value
                                                                        .toString());
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                itemCount: 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "نوع اليد",
                                        style: textStyle.middleTSBasic.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 200.h,
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 15.w),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                  handTypeValue = attribut
                                                      .result!
                                                      .typehandlist![index]
                                                      .id!;
                                                  hand = hands[index];
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 30.w),
                                                  child: Column(
                                                    children: [
                                                      Image.network(
                                                        attribut
                                                            .result!
                                                            .typehandlist![
                                                                index]
                                                            .image!,
                                                        width: 80.w,
                                                        height: 80.h,
                                                      ),
                                                      Radio(
                                                        value: attribut
                                                            .result!
                                                            .typehandlist![
                                                        index]
                                                            .id!,
                                                        groupValue:
                                                        handTypeValue,
                                                        onChanged:
                                                            (value) {
                                                          setState(() {
                                                            handTypeValue =
                                                            value!
                                                            as int;
                                                          });
                                                          print("aaaaaaaaaaaaaaaaaa" +
                                                              value
                                                                  .toString());
                                                        },
                                                      ),
                                                      onlyTextField(
                                                          hands[index],
                                                          index: 2)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          itemCount: 3),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "اكسسوار الجيب",
                                        style: textStyle.middleTSBasic.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 200.h,
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 15.w),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return index != 0
                                                ? InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                      geepExcesoryTypeValue =
                                                          attribut
                                                              .result!
                                                              .pockettypelist![
                                                                  index]
                                                              .id!;
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30.w),
                                                      child: Column(
                                                        children: [
                                                          Image.network(
                                                            attribut
                                                                .result!
                                                                .pockettypelist![
                                                                    index]
                                                                .image!,
                                                            width: 80.w,
                                                            height: 80.h,
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .03,
                                                          ),
                                                          Text(attribut
                                                              .result!
                                                              .pockettypelist![
                                                                  index]
                                                              .name!),
                                                          Radio(
                                                            value: attribut
                                                                .result!
                                                                .pockettypelist![
                                                                    index]
                                                                .id!,
                                                            groupValue:
                                                                geepExcesoryTypeValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                geepExcesoryTypeValue =
                                                                    value!
                                                                        as int;
                                                              });
                                                              print("aaaaaaaaaaaaaaaaaa" +
                                                                  value
                                                                      .toString());
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        geepExcesoryTypeValue =
                                                        attribut
                                                            .result!
                                                            .pockettypelist![
                                                        index]
                                                            .id!;
                                                        marks[2]= !marks[2];
                                                        marks[0]= false;
                                                        marks[1]= false;
                                                      });
                                                    },
                                                    child:
                                                        customTextTextWithColor(
                                                            attribut
                                                                .result!
                                                                .pockettypelist![
                                                                    index]
                                                                .name, marks[2]),
                                                  );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "نوع الأزراير",
                                        style: textStyle.middleTSBasic.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      height: 200.h,
                                      padding: EdgeInsets.only(
                                          left: 15.w, right: 15.w),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return index != 0 && index != 1
                                                ? InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                      zraierTypeValue = attribut
                                                          .result!
                                                          .acctypeslist![index]
                                                          .id!;
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30.w),
                                                      child: Column(
                                                        children: [
                                                          Image.network(
                                                            attribut
                                                                .result!
                                                                .acctypeslist![
                                                                    index]
                                                                .image!,
                                                            width: 80.w,
                                                            height: 80.h,
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .03,
                                                          ),
                                                          Text(attribut
                                                              .result!
                                                              .acctypeslist![
                                                                  index]
                                                              .name!),
                                                          Radio(
                                                            value: attribut
                                                                .result!
                                                                .acctypeslist![
                                                                    index]
                                                                .id!,
                                                            groupValue:
                                                                zraierTypeValue,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                zraierTypeValue =
                                                                    value!
                                                                        as int;
                                                              });
                                                              print("aaaaaaaaaaaaaaaaaa" +
                                                                  value
                                                                      .toString());
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        marks[2]= false;
                                                        marks[index]= !marks[index];
                                                        zraierTypeValue =
                                                            attribut
                                                                .result!
                                                                .acctypeslist![
                                                                    index]
                                                                .id!;
                                                      });
                                                    },
                                                    child:
                                                        customTextTextWithColor(
                                                            attribut
                                                                .result!
                                                                .acctypeslist![
                                                                    index]
                                                                .name, marks[index]),
                                                  );
                                            /**/
                                          }),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    customTextField('ملاحظات', notes,
                                        width: 0.w),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Consumer<CartProvider>(builder:
                                        (context, quizProvider, child) {
                                      return Center(
                                        child: RaisedButton(
                                          color: globalColor.primaryColor,
                                          textColor: Colors.white,
                                          // color: Colors.greenAccent,
                                          // borderSide: BorderSide(
                                          //   width: .5,
                                          //   color: Colors.black,
                                          //   style:
                                          //   BorderStyle.solid,
                                          // ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: () async {
                                            if (yakaTypeValue == null ||
                                                geepExcesoryTypeValue == null ||
                                                handTypeValue == null ||
                                                gypsourTypeValue == null ||
                                                geepTypeValue == null ||
                                                zraierTypeValue == null ||
                                               // yaka.text == null ||
                                               // hand.text == "" ||
                                                length.text == "" ||
                                                waist.text == "" ||
                                                notes.text == "" ||
                                                shoulder.text == "" ||
                                                //handLength.text == "" ||
                                                neck.text == "" ||
                                                bat.text == "" ||
                                                Belowbat.text == "" ||
                                                jisor.text == "" ||
                                                step.text == "" ||
                                                elbow.text == "") {
                                              Fluttertoast.showToast(
                                                  msg: "يرجي استكمال البيانات",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.sp);
                                            } else {
                                              /* Get.Get.toNamed(
                                                CartPage.routeName,
                                                parameters: {"type": "tafsil"},
                                                arguments: CartPageTafsilArgs(
                                                    length: length.text,
                                                    neck: neck.text,
                                                    geepExcesoryTypeValue:
                                                        geepExcesoryTypeValue,
                                                    hand: hand.text,
                                                    waist: waist.text,
                                                    yakaTypeValue: yakaTypeValue,
                                                    Belowbat: Belowbat.text,
                                                    shoulder: shoulder.text,
                                                    zraierTypeValue:
                                                        zraierTypeValue,
                                                    yaka: yaka.text,
                                                    gypsourTypeValue:
                                                        gypsourTypeValue,
                                                    bat: bat.text,
                                                    elbow: elbow.text,
                                                    handTypeValue: handTypeValue,
                                                    geepTypeValue: geepTypeValue,
                                                    notes: notes.text,
                                                    handLength: handLength.text,
                                                    step: step.text,
                                                    jisor: jisor.text),
                                              );*/
                                              if (await UserRepository
                                                  .hasToken) {
                                                quizProvider.addItemAttributeToCart(
                                                    CartAttributeEntity(
                                                        id: widget.id,
                                                        image: widget.image,
                                                        count: 1,
                                                        Belowbat: Belowbat.text,
                                                        geepExcesoryTypeValue:
                                                            geepExcesoryTypeValue,
                                                        yakaTypeValue:
                                                            yakaTypeValue,
                                                        length: length.text,
                                                        jisor: jisor.text,
                                                        gypsourTypeValue:
                                                            gypsourTypeValue,
                                                        name: widget.name,
                                                        price: widget.price,
                                                        handTypeValue:
                                                            handTypeValue,
                                                        notes: notes.text,
                                                        handLength:
                                                            handLength.text,
                                                        shoulder: shoulder.text,
                                                        zraierTypeValue:
                                                            zraierTypeValue,
                                                        neck: neck.text,
                                                        waist: waist.text,
                                                        hand: hand.text,
                                                        yaka: yaka.text,
                                                        discountPrice: widget
                                                            .discountPrice,
                                                        geepTypeValue:
                                                            geepTypeValue,
                                                        elbow: elbow.text,
                                                        bat: bat.text,
                                                        step: step.text));

                                                print(
                                                    '${quizProvider.getAttributeItems()!.length}');
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      AddToCartDialog(
                                                    parameters: {
                                                      "type": "tafseel"
                                                    },
                                                  ),
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      LoginFirstDialog(),
                                                );
                                              }
                                            }

                                            // storeOrder(name: null, phone: null, address: null, count_item: null, length: null, waist: null, chest: null, shoulder: null, hand: null, neck: null, armpit: null, elbow: null, gypsour: null, step: null, pocket_type: null, type_hand: null, tailor_id: null, model_id: null, pocket_id: null, acctype_id: null, fabric_id: null, accnum_id: null, addition_id: null, collar_id: null, note: null)
                                          },
                                          child: Text(
                                            "اضافة للسلة",
                                            style: textStyle.middleTSBasic
                                                .copyWith(
                                              color: globalColor.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
    );
  }

  onlyTextField(textController, {double? width, int? index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width == null ? 80.w : MediaQuery.of(context).size.width,
        height: 50.h,
        child: TextFormField(
          validator: (v) {
            if (v!.length == 0) {
              return "";
            }
            return null;
          },
          controller: textController,
          decoration: InputDecoration(
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: globalColor.primaryColor),
              //   borderRadius: BorderRadius.only(
              //       bottomRight: Radius.circular(5.w),
              //       bottomLeft: Radius.circular(5.w)),
              // ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: globalColor.primaryColor),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5.w),
                    bottomLeft: Radius.circular(5.w)),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "",
              fillColor: Colors.white70),
        ),
      ),
    );
  }

  customTextField(title, textController, {double? width}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Container(
              width: width == null ? 80.w : MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: globalColor.grey.withOpacity(.2)),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 0),
                child: Text(
                  title,
                  style:
                      textStyle.smallTSBasic.copyWith(color: globalColor.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: width == null ? 80.w : MediaQuery.of(context).size.width,
              height: 50.h,
              child: TextFormField(
                validator: (v) {
                  if (v!.length == 0) {
                    return "";
                  }
                  return null;
                },
                controller: textController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: globalColor.primaryColor),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: globalColor.primaryColor),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "",
                    fillColor: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  customTextWithColor(title, value) {
    return Container(
      //width: 80,
      //  height: 50.h,

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: value==true? Colors.green: globalColor.green.withOpacity(.2)),
          color: globalColor.grey.withOpacity(.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Text(
          title,
          style: textStyle.smallTSBasic.copyWith(color: globalColor.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  customTextTextWithColor(title, id) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            //width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: id ==true
                        ? Colors.green
                        : Colors.grey.withOpacity(.2),
                    width: 1.w),
                color: globalColor.grey.withOpacity(.2)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
              child: Center(
                child: Text(
                  title,
                  style:
                      textStyle.smallTSBasic.copyWith(color: globalColor.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildTopAds(
      {
      //required GeneralProductModel productModel,
      required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // color: Colors.green,
      width: width,
      height: 150.h,
      child: Stack(
        children: [
          PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: adds
                .map((item) => ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: ItemOfferWidget(
                        offerItem: item,
                        width: width,
                      ),
                    ))
                .toList(),
          ),
          Positioned(
              bottom: 8,
              right: 0,
              left: 0,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: _buildPageIndicator2(width: width, count: 5)))
        ],
      ),
    );
  }

  _buildPageIndicator2({double? width, int? count}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: width,
      child: SmoothPageIndicator(
          controller: controller, //// PageController
          count: count!,
          effect: WormEffect(
            spacing: 8.0,
            radius: 9.0,
            dotWidth: 8.0,
            dotHeight: 8.0,
            dotColor: Colors.white,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 2,
            activeDotColor: globalColor.primaryColor,
          ), // your preferred effect
          onDotClicked: (index) {}),
    );
  }
}

class dropdownWidget extends StatelessWidget {
  const dropdownWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AwesomeDropDown(
      dropDownList: [
        "صغير",
        "لارج",
        "اكس لارج",
        "اكس لارج2",
        "اكس لارج3",
      ],
      padding: 8,
      dropDownIcon: Icon(
        Icons.arrow_drop_down,
        color: Colors.grey,
        size: 23,
      ),
      elevation: 5,
      dropDownBorderRadius: 10,
      dropDownTopBorderRadius: 50,
      dropDownBottomBorderRadius: 50,
      dropDownIconBGColor: Colors.transparent,
      dropDownOverlayBGColor: Colors.transparent,
      dropDownBGColor: Colors.white,
      selectedItem: 'أختر مقاسك',
      numOfListItemToShow: 4,
      selectedItemTextStyle: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      dropDownListTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.transparent),
    );
  }
}

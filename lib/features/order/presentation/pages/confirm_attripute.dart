/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/validators/required_validator.dart';
import 'package:ojos_app/core/validators/year_validator.dart';
import 'package:ojos_app/features/order/data/api_responses/feach_attripute.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';

class ConfirmAttripute extends StatelessWidget {
  int count_item;
  int length;
  // int waist;
  int chest;
  int shoulder;
  int hand;
  int neck;
  int armpit;
  int elbow;
  int gypsour;
  int step;
  int pocket_type;
  int type_hand;
  int tailor_id;
  int model_id;
  int pocket_id;
  int acctype_id;
  // int fabric_id;
  // int accnum_id;
  // int addition_id;
  // int embroidery_id;   *********** تطريز سليم  **********
  int collar_id;
  int filling;
  int gypsourType;

  ConfirmAttripute(
      {required this.gypsourType,
      required this.gypsour,
      required this.filling,
      required this.count_item,
      required this.length,
      // required this.waist,
      required this.chest,
      required this.shoulder,
      required this.hand,
      required this.neck,
      required this.armpit,
      required this.elbow,
      required this.step,
      required this.pocket_type,
      required this.type_hand,
      required this.tailor_id,
      required this.model_id,
      required this.pocket_id,
      required this.acctype_id,
      // required this.fabric_id,
      // required this.accnum_id,
      // required this.addition_id,
      // required this.embroidery_id,     *********** تطريز سليم  **********
      required this.collar_id});

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController nots = TextEditingController();
  TextEditingController time = TextEditingController();

  final globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          Translations.of(context).translate("complete_order"),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: globalKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // validator: (value) => requiredValidation(context, value),
                controller: name,
                textAlign: TextAlign.center,
                // controller: searchCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'المستلم',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // validator: (value) => phoneValidation(context, value!),

                controller: phone,
                textAlign: TextAlign.center,
                // controller: searchCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'الهاتف',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: address,
                // validator: (value) => requiredValidation(context, value),

                textAlign: TextAlign.center,
                // controller: searchCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'العنوان',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nots,
                maxLines: 2,
                textAlign: TextAlign.center,
                // controller: searchCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'ملاحظة',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: time,
                maxLines: 2,
                textAlign: TextAlign.center,
                // controller: searchCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'موعد التوصيل',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () async {
                  if (globalKey.currentState!.validate()) {
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    final String formatted = formatter.format(now);

                    storeOrder(context,
                        order_date: formatted,
                        gypsourtype: gypsourType,
                        fillingtype: filling,
                        name: name.text,
                        phone: phone.text,
                        address: address.text,
                        count_item: length,
                        length: length,
                        // waist: waist,
                        chest: chest,
                        shoulder: shoulder,
                        hand: hand,
                        neck: neck,
                        armpit: armpit,
                        elbow: elbow,
                        gypsour: gypsour,
                        step: step,
                        pocket_type: pocket_type,
                        type_hand: type_hand,
                        tailor_id: tailor_id,
                        model_id: model_id,
                        pocket_id: pocket_id,
                        acctype_id: acctype_id,
                        // fabric_id: fabric_id,
                        // accnum_id: accnum_id,
                        // addition_id: addition_id,
                        // embroidery_id: embroidery_id,    *********** تطريز سليم  **********
                        collar_id: collar_id,
                        visiting: time.text,
                        note: nots.text);
                  }
// if()

                  // storeOrder(name: null, phone: null, address: null, count_item: null, length: null, waist: null, chest: null, shoulder: null, hand: null, neck: null, armpit: null, elbow: null, gypsour: null, step: null, pocket_type: null, type_hand: null, tailor_id: null, model_id: null, pocket_id: null, acctype_id: null, fabric_id: null, accnum_id: null, addition_id: null, collar_id: null, note: null)
                },
                child: Text(
                  "طلب الان",
                  style: textStyle.middleTSBasic.copyWith(
                    color: globalColor.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

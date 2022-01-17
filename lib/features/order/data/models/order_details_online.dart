// To parse this JSON data, do
//
//     final orderDetailsOnline = orderDetailsOnlineFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderDetailsOnline orderDetailsOnlineFromJson(String str) =>
    OrderDetailsOnline.fromJson(json.decode(str));

String orderDetailsOnlineToJson(OrderDetailsOnline data) =>
    json.encode(data.toJson());

class OrderDetailsOnline {
  OrderDetailsOnline({
    required this.status,
    required this.msg,
    required this.result,
  });

  bool status;
  String msg;
  Result result;

  factory OrderDetailsOnline.fromJson(Map<String, dynamic> json) =>
      OrderDetailsOnline(
        status: json["status"],
        msg: json["msg"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "result": result.toJson(),
      };
}

class Result {
  Result(
      {required this.id,
      required this.uuid,
      required this.userId,
      required this.delegateId,
      required this.couponId,
      required this.coupon,
      required this.orderimage,
      required this.deliveryFee,
      required this.tax,
      required this.subtotal,
      required this.discount,
      required this.paidAmount,
      required this.remainingAmount,
      required this.methodId,
      required this.paymentMehtod,
      required this.status,
      required this.name,
      required this.phone,
      required this.address,
      required this.note,
      required this.length,
      required this.waist,
      required this.shoulder,
      required this.hand,
      required this.neck,
      required this.neckLength,
      required this.armpit,
      required this.elbow,
      required this.cupcake,
      required this.gypsour,
      required this.step,
      required this.stepWidth,
      required this.sleeveLength,
      required this.sleeveWidth,
      required this.tailor,
      required this.model,
      required this.pocket,
      required this.accdress,
      required this.acctype,
      required this.fabric,
      required this.accnum,
      required this.addition,
      required this.collar,
      required this.pocketType,
      required this.typeHand,
      required this.order_date,
      required this.gypsourtype,
      required this.fillingtype});

  String gypsourtype;
  String fillingtype;
  int id;
  String uuid;
  int userId;
  int? delegateId;
  int? couponId;
  String coupon;
  String orderimage;
  int deliveryFee;
  int tax;
  int subtotal;
  int discount;
  int paidAmount;
  int remainingAmount;
  dynamic methodId;
  String paymentMehtod;
  String status;
  String name;
  String phone;
  String address;
  String note;
  String? order_date;
  int length;
  int waist;
  int shoulder;
  int hand;
  int neck;
  int neckLength;
  int armpit;
  int elbow;
  int cupcake;
  int gypsour;
  int step;
  int stepWidth;
  int sleeveLength;
  int sleeveWidth;
  String tailor;
  String model;
  String pocket;
  String accdress;
  String acctype;
  String fabric;
  String accnum;
  String addition;
  String collar;
  String pocketType;
  String typeHand;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        gypsourtype: json['gypsourtype'],
        fillingtype: json['fillingtype'],
        id: json["id"],
        uuid: json["uuid"],
        userId: json["user_id"],
        delegateId: json["delegate_id"],
        couponId: json["coupon_id"],
        coupon: json["coupon"],
        orderimage: json["orderimage"],
        deliveryFee: json["delivery_fee"],
        tax: json["tax"],
        subtotal: json["subtotal"],
        discount: json["discount"],
        paidAmount: json["paid_amount"],
        remainingAmount: json["remaining_amount"],
        methodId: json["method_id"],
        paymentMehtod: json["payment_mehtod"],
        status: json["status"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        note: json["note"],
        length: json["length"],
        waist: json["waist"],
        shoulder: json["shoulder"],
        hand: json["hand"],
        neck: json["neck"],
        neckLength: json["neck_length"],
        armpit: json["armpit"],
        elbow: json["elbow"],
        cupcake: json["cupcake"],
        gypsour: json["gypsour"],
        step: json["step"],
        stepWidth: json["step_width"],
        sleeveLength: json["sleeve_length"],
        sleeveWidth: json["sleeve_width"],
        tailor: json["tailor"],
        model: json["model"],
        pocket: json["pocket"],
        accdress: json["accdress"],
        acctype: json["acctype"],
        fabric: json["fabric"],
        accnum: json["accnum"],
        order_date: json['order_date'],
        addition: json["addition"],
        collar: json["collar"],
        pocketType: json["pocket_type"],
        typeHand: json["type_hand"],
      );

  Map<String, dynamic> toJson() => {
        'gypsourtype': gypsourtype,
        'fillingtype': fillingtype,
        "id": id,
        "uuid": uuid,
        "user_id": userId,
        "delegate_id": delegateId,
        "coupon_id": couponId,
        "coupon": coupon,
        "orderimage": orderimage,
        "delivery_fee": deliveryFee,
        "tax": tax,
        "subtotal": subtotal,
        "discount": discount,
        "paid_amount": paidAmount,
        "remaining_amount": remainingAmount,
        "method_id": methodId,
        "payment_mehtod": paymentMehtod,
        "status": status,
        "name": name,
        "phone": phone,
        "address": address,
        "note": note,
        "length": length,
        "waist": waist,
        "shoulder": shoulder,
        "hand": hand,
        "neck": neck,
        "neck_length": neckLength,
        "armpit": armpit,
        "elbow": elbow,
        "cupcake": cupcake,
        "gypsour": gypsour,
        "step": step,
        "step_width": stepWidth,
        "sleeve_length": sleeveLength,
        "sleeve_width": sleeveWidth,
        "tailor": tailor,
        "model": model,
        "pocket": pocket,
        "accdress": accdress,
        "acctype": acctype,
        "fabric": fabric,
        "accnum": accnum,
        "addition": addition,
        "collar": collar,
        "pocket_type": pocketType,
        "type_hand": typeHand,
        'order_date': order_date
      };
}

class OrderOnlineRequest {
  String? accdress;
  String? accnum;
  String? acctype;
  String? addition;
  String? address;
  int? armpit;
  String? collar;
  String? coupon;
  // Object coupon_id;
  // Object cupcake;
  // Object delegate_id;
  int? delivery_fee;
  int? discount;
  int? elbow;
  String? fabric;
  String? fillingtype;
  int? gypsour;
  String? gypsourtype;
  int? hand;
  int? id;
  int? length;
  // Object method_id;
  String? model;
  String? name;
  int? neck;
  // Object neck_length;
  String? note;
  String? order_date;
  String? orderimage;
  int? paid_amount;
  String? payment_mehtod;
  String? phone;
  String? pocket;
  String? pocket_type;
  int? remaining_amount;
  int? shoulder;
  // Object sleeve_length;
  // Object sleeve_width;
  String? status;
  int? step;
  // Object step_width;
  int? subtotal;
  String? tailor;
  int? tax;
  String? type_hand;
  int? user_id;
  String? uuid;
  String? visiting;
  int? waist;

  OrderOnlineRequest(
      {this.accdress,
      this.accnum,
      this.acctype,
      this.addition,
      this.address,
      this.armpit,
      this.collar,
      this.coupon,
      // this.coupon_id,
      // this.cupcake,
      // this.delegate_id,
      this.delivery_fee,
      this.discount,
      this.elbow,
      this.fabric,
      this.fillingtype,
      this.gypsour,
      this.gypsourtype,
      this.hand,
      this.id,
      this.length,
      //this.method_id,
      this.model,
      this.name,
      this.neck,
      // this.neck_length,
      this.note,
      this.order_date,
      this.orderimage,
      this.paid_amount,
      this.payment_mehtod,
      this.phone,
      this.pocket,
      this.pocket_type,
      this.remaining_amount,
      this.shoulder,
      // this.sleeve_length,
      // this.sleeve_width,
      this.status,
      this.step,
      // this.step_width,
      this.subtotal,
      this.tailor,
      this.tax,
      this.type_hand,
      this.user_id,
      this.uuid,
      this.visiting,
      this.waist});

  factory OrderOnlineRequest.fromJson(Map<String, dynamic> json) {
    return OrderOnlineRequest(
      accdress: json['accdress'],
      accnum: json['accnum'],
      acctype: json['acctype'],
      addition: json['addition'],
      address: json['address'],
      armpit: json['armpit'],
      collar: json['collar'],
      coupon: json['coupon'],
      // coupon_id:
      //     json['coupon_id'] != null ? Object.fromJson(json['coupon_id']) : null,
      // cupcake:
      //     json['cupcake'] != null ? Object.fromJson(json['cupcake']) : null,
      // delegate_id: json['delegate_id'] != null
      //     ? Object.fromJson(json['delegate_id'])
      //: null,
      delivery_fee: json['delivery_fee'],
      discount: json['discount'],
      elbow: json['elbow'],
      fabric: json['fabric'],
      fillingtype: json['fillingtype'],
      gypsour: json['gypsour'],
      gypsourtype: json['gypsourtype'],
      hand: json['hand'],
      id: json['id'],
      length: json['length'],
      // method_id:
      //     json['method_id'] != null ? Object.fromJson(json['method_id']) : null,
      model: json['model'],
      name: json['name'],
      neck: json['neck'],
      // neck_length: json['neck_length'] != null
      //     ? Object.fromJson(json['neck_length'])
      //     : null,
      note: json['note'],
      order_date: json['order_date'],
      orderimage: json['orderimage'],
      paid_amount: json['paid_amount'],
      payment_mehtod: json['payment_mehtod'],
      phone: json['phone'],
      pocket: json['pocket'],
      pocket_type: json['pocket_type'],
      remaining_amount: json['remaining_amount'],
      shoulder: json['shoulder'],
      // sleeve_length: json['sleeve_length'] != null
      //     ? Object.fromJson(json['sleeve_length'])
      //     : null,
      // sleeve_width: json['sleeve_width'] != null
      //     ? Object.fromJson(json['sleeve_width'])
      //     : null,
      // status: json['status'],
      // step: json['step'],
      // step_width: json['step_width'] != null
      //     ? Object.fromJson(json['step_width'])
      //     : null,
      subtotal: json['subtotal'],
      tailor: json['tailor'],
      tax: json['tax'],
      type_hand: json['type_hand'],
      user_id: json['user_id'],
      uuid: json['uuid'],
      visiting: json['visiting'],
      waist: json['waist'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accdress'] = this.accdress;
    data['accnum'] = this.accnum;
    data['acctype'] = this.acctype;
    data['addition'] = this.addition;
    data['address'] = this.address;
    data['armpit'] = this.armpit;
    data['collar'] = this.collar;
    data['coupon'] = this.coupon;
    data['delivery_fee'] = this.delivery_fee;
    data['discount'] = this.discount;
    data['elbow'] = this.elbow;
    data['fabric'] = this.fabric;
    data['fillingtype'] = this.fillingtype;
    data['gypsour'] = this.gypsour;
    data['gypsourtype'] = this.gypsourtype;
    data['hand'] = this.hand;
    data['id'] = this.id;
    data['length'] = this.length;
    data['model'] = this.model;
    data['name'] = this.name;
    data['neck'] = this.neck;
    data['note'] = this.note;
    data['order_date'] = this.order_date;
    data['orderimage'] = this.orderimage;
    data['paid_amount'] = this.paid_amount;
    data['payment_mehtod'] = this.payment_mehtod;
    data['phone'] = this.phone;
    data['pocket'] = this.pocket;
    data['pocket_type'] = this.pocket_type;
    data['remaining_amount'] = this.remaining_amount;
    data['shoulder'] = this.shoulder;
    data['status'] = this.status;
    data['step'] = this.step;
    data['subtotal'] = this.subtotal;
    data['tailor'] = this.tailor;
    data['tax'] = this.tax;
    data['type_hand'] = this.type_hand;
    data['user_id'] = this.user_id;
    data['uuid'] = this.uuid;
    data['visiting'] = this.visiting;
    data['waist'] = this.waist;
    // if (this.coupon_id != null) {
    //   data['coupon_id'] = this.coupon_id.toJson();
    // }
    // if (this.cupcake != null) {
    //   data['cupcake'] = this.cupcake.toJson();
    // }
    // if (this.delegate_id != null) {
    //   data['delegate_id'] = this.delegate_id.toJson();
    // }
    // if (this.method_id != null) {
    //   data['method_id'] = this.method_id.toJson();
    // }
    // if (this.neck_length != null) {
    //   data['neck_length'] = this.neck_length.toJson();
    // }
    // if (this.sleeve_length != null) {
    //   data['sleeve_length'] = this.sleeve_length.toJson();
    // }
    // if (this.sleeve_width != null) {
    //   data['sleeve_width'] = this.sleeve_width.toJson();
    // }
    // if (this.step_width != null) {
    //   data['step_width'] = this.step_width.toJson();
    // }
    return data;
  }
}

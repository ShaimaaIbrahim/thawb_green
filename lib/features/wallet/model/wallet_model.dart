class WalletResponse {
  late List<WalletDataBean> data;

  WalletResponse({required this.data});

  WalletResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <WalletDataBean>[];
      json['data'].forEach((v) {
        data.add(new WalletDataBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WalletDataBean {
  late int id;
  late List<String> productName;
  late String clientName;
  late String walletAmount;
  late String createdAt;
  late String updatedAt;

  WalletDataBean(
      {required this.id,
        required  this.productName,
        required  this.clientName,
        required  this.walletAmount,
        required  this.createdAt,
        required  this.updatedAt});

  WalletDataBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'].cast<String>();
    clientName = json['client_name'];
    walletAmount = json['wallet_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['client_name'] = this.clientName;
    data['wallet_amount'] = this.walletAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

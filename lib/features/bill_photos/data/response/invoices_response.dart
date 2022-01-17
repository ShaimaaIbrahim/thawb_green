class InvoicesResponse {
  InvoicesResponse({
      List<Data>? data,}){
    _data = data;
}

  InvoicesResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  List<Data>? _data;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      int? id, 
      List<String>? user, 
      String? invoice,}){
    _id = id;
    _user = user;
    _invoice = invoice;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? json['user'].cast<String>() : [];
    _invoice = json['invoice'];
  }
  int? _id;
  List<String>? _user;
  String? _invoice;

  int? get id => _id;
  List<String>? get user => _user;
  String? get invoice => _invoice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user'] = _user;
    map['invoice'] = _invoice;
    return map;
  }

}
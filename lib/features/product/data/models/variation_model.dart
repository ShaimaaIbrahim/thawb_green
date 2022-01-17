/// id : 3
/// cloth_color : "اسود"
/// cloth_hight : "123سم"
/// cloth_size : "XL"
/// cloth_type : "حرير"
/// created_at : "2022-01-02T18:15:11.000000Z"
/// updated_at : "2022-01-02T18:15:11.000000Z"

class VariationModel {
  VariationModel({
      int? id, 
      String? clothColor, 
      String? clothHight, 
      String? clothSize, 
      String? clothType, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _clothColor = clothColor;
    _clothHight = clothHight;
    _clothSize = clothSize;
    _clothType = clothType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  VariationModel.fromJson(dynamic json) {
    _id = json['id'];
    _clothColor = json['cloth_color'];
    _clothHight = json['cloth_hight'];
    _clothSize = json['cloth_size'];
    _clothType = json['cloth_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _clothColor;
  String? _clothHight;
  String? _clothSize;
  String? _clothType;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get clothColor => _clothColor;
  String? get clothHight => _clothHight;
  String? get clothSize => _clothSize;
  String? get clothType => _clothType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['cloth_color'] = _clothColor;
    map['cloth_hight'] = _clothHight;
    map['cloth_size'] = _clothSize;
    map['cloth_type'] = _clothType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}
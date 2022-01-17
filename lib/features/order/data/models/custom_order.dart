class OrderAttributeModel {
  bool? status;
  String? msg;
  Result? result;

  OrderAttributeModel({this.status, this.msg, this.result});

  OrderAttributeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  List<Modelslist>? modelslist;
  List<Tailorslist>? tailorslist;
  List<Pocketslist>? pocketslist;
  List<Accdresslist>? accdresslist;
  List<Acctypeslist>? acctypeslist;
  List<Fabricslist>? fabricslist;
  List<Accnumlist>? accnumlist;
  List<Additionslist>? additionslist;
  //List<Embroiderylist>? embroiderylist;   //  *************** ليست تطريز ****************************
  List<Collarlist>? collarlist;
  List<Pockettypelist>? pockettypelist;
  List<Typehandlist>? typehandlist;
  List<Typehandlist>? gypsourlist;
  List<Typehandlist>? fillingtype;

  Result(
      {this.modelslist,
      this.tailorslist,
      this.pocketslist,
      this.accdresslist,
      this.acctypeslist,
      this.fabricslist,
      this.accnumlist,
      this.additionslist,
      this.collarlist,
      this.pockettypelist,
      this.typehandlist});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['modelslist'] != null) {
      modelslist = [];
      json['modelslist'].forEach((v) {
        modelslist!.add(new Modelslist.fromJson(v));
      });
    }
    if (json['tailorslist'] != null) {
      tailorslist = [];
      json['tailorslist'].forEach((v) {
        tailorslist!.add(new Tailorslist.fromJson(v));
      });
    }
    if (json['pocketslist'] != null) {
      pocketslist = [];
      json['pocketslist'].forEach((v) {
        pocketslist!.add(new Pocketslist.fromJson(v));
      });
    }
    if (json['accdresslist'] != null) {
      accdresslist = [];
      json['accdresslist'].forEach((v) {
        accdresslist!.add(new Accdresslist.fromJson(v));
      });
    }
    if (json['acctypeslist'] != null) {
      acctypeslist = [];
      json['acctypeslist'].forEach((v) {
        acctypeslist!.add(new Acctypeslist.fromJson(v));
      });
    }
    if (json['fabricslist'] != null) {
      fabricslist = [];
      json['fabricslist'].forEach((v) {
        fabricslist!.add(new Fabricslist.fromJson(v));
      });
    }
    if (json['accnumlist'] != null) {
      accnumlist = [];
      json['accnumlist'].forEach((v) {
        accnumlist!.add(new Accnumlist.fromJson(v));
      });
    }
    if (json['additionslist'] != null) {
      additionslist = [];
      json['additionslist'].forEach((v) {
        additionslist!.add(new Additionslist.fromJson(v));
      });
    }
    if (json['collarlist'] != null) {
      collarlist = [];
      json['collarlist'].forEach((v) {
        collarlist!.add(new Collarlist.fromJson(v));
      });
    }
    if (json['pockettypelist'] != null) {
      pockettypelist = [];
      json['pockettypelist'].forEach((v) {
        pockettypelist!.add(new Pockettypelist.fromJson(v));
      });
    }
    if (json['typehandlist'] != null) {
      typehandlist = [];
      json['typehandlist'].forEach((v) {
        typehandlist!.add(new Typehandlist.fromJson(v));
      });
    }
    if (json['gypsourlist'] != null) {
      gypsourlist = [];
      json['gypsourlist'].forEach((v) {
        gypsourlist!.add(new Typehandlist.fromJson(v));
      });
    }
    if (json['fillingtype'] != null) {
      fillingtype = [];
      json['fillingtype'].forEach((v) {
        fillingtype!.add(new Typehandlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.modelslist != null) {
      data['modelslist'] = this.modelslist!.map((v) => v.toJson()).toList();
    }
    if (this.tailorslist != null) {
      data['tailorslist'] = this.tailorslist!.map((v) => v.toJson()).toList();
    }
    if (this.pocketslist != null) {
      data['pocketslist'] = this.pocketslist!.map((v) => v.toJson()).toList();
    }
    if (this.accdresslist != null) {
      data['accdresslist'] = this.accdresslist!.map((v) => v.toJson()).toList();
    }
    if (this.acctypeslist != null) {
      data['acctypeslist'] = this.acctypeslist!.map((v) => v.toJson()).toList();
    }
    if (this.fabricslist != null) {
      data['fabricslist'] = this.fabricslist!.map((v) => v.toJson()).toList();
    }
    if (this.accnumlist != null) {
      data['accnumlist'] = this.accnumlist!.map((v) => v.toJson()).toList();
    }
    if (this.additionslist != null) {
      data['additionslist'] =
          this.additionslist!.map((v) => v.toJson()).toList();
    }
    if (this.collarlist != null) {
      data['collarlist'] = this.collarlist!.map((v) => v.toJson()).toList();
    }
    if (this.pockettypelist != null) {
      data['pockettypelist'] =
          this.pockettypelist!.map((v) => v.toJson()).toList();
    }
    if (this.typehandlist != null) {
      data['typehandlist'] = this.typehandlist!.map((v) => v.toJson()).toList();
    }
    if (this.gypsourlist != null) {
      data['gypsourlist'] = this.gypsourlist!.map((v) => v.toJson()).toList();
    }
    if (this.fillingtype != null) {
      data['fillingtype'] = this.fillingtype!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modelslist {
  int? id;
  String? name;
  var value;
  String? image;

  Modelslist({this.id, this.name, this.value, this.image});

  Modelslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Tailorslist {
  int? id;
  String? name;
  var value;
  String? image;

  Tailorslist({this.id, this.name, this.value, this.image});

  Tailorslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Pocketslist {
  int? id;
  String? name;
  var value;
  String? image;

  Pocketslist({this.id, this.name, this.value, this.image});

  Pocketslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Accdresslist {
  int? id;
  String? name;
  var value;
  String? image;

  Accdresslist({this.id, this.name, this.value, this.image});

  Accdresslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Acctypeslist {
  int? id;
  String? name;
  var value;
  String? image;

  Acctypeslist({this.id, this.name, this.value, this.image});

  Acctypeslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Fabricslist {
  int? id;
  String? name;
  var value;
  String? image;

  Fabricslist({this.id, this.name, this.value, this.image});

  Fabricslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Accnumlist {
  int? id;
  String? name;
  var value;
  String? image;

  Accnumlist({this.id, this.name, this.value, this.image});

  Accnumlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Additionslist {
  int? id;
  String? name;
  var value;
  String? image;

  Additionslist({this.id, this.name, this.value, this.image});

  Additionslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}
/*
class Embroiderylist {
  int? id;
  String? name;
  var value;
  String? image;

  Embroiderylist({this.id, this.name, this.value, this.image});

  Embroiderylist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}
*/

class Collarlist {
  int? id;
  String? name;
  var value;
  String? image;

  Collarlist({this.id, this.name, this.value, this.image});

  Collarlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Pockettypelist {
  int? id;
  String? name;
  var value;
  String? image;

  Pockettypelist({this.id, this.name, this.value, this.image});

  Pockettypelist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

class Typehandlist {
  int? id;
  String? name;
  var value;
  String? image;

  Typehandlist({this.id, this.name, this.value, this.image});

  Typehandlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['value'] = this.value;
    data['image'] = this.image;
    return data;
  }
}

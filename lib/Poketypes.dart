class Poketypes {
  int? poketypeId;
  String? name;

  Poketypes({this.poketypeId, this.name});

  Poketypes.fromJson(Map<String, dynamic> json) {poketypeId = json['poketypeId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poketypeId'] = this.poketypeId;
    data['name'] = this.name;
    return data;
  }
}
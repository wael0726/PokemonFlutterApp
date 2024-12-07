class Species {
  int? speciesId;
  String? name;

  Species({this.speciesId, this.name});

  Species.fromJson(Map<String, dynamic> json) {speciesId = json['speciesId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speciesId'] = this.speciesId;
    data['name'] = this.name;
    return data;
  }
}
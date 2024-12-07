class Habitat {
  int? habitatId;
  String? name;

  Habitat({this.habitatId, this.name});

  Habitat.fromJson(Map<String, dynamic> json) {habitatId = json['habitatId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {final Map<String, dynamic> data = new Map<String, dynamic>();
    data['habitatId'] = this.habitatId;
    data['name'] = this.name;
    return data;
  }
}
import 'Habitat.dart';
import 'Poketypes.dart';
import 'Species.dart';

class Pokemon {int? pokemonId;String? name;String? color;String? thumbURL;String? imgURL;String? cryURL;Habitat? habitat;Species? species;List<Poketypes>? poketypes;Pokemon? evolution;
  Pokemon({this.pokemonId, this.name, this.color, this.thumbURL, this.imgURL, this.cryURL, this.habitat, this.species, this.poketypes, this.evolution});

  Pokemon.fromJson(Map<String, dynamic> json) {
    pokemonId = json['pokemonId'];
    name = json['name'];
    color = json['color'];
    thumbURL = json['thumbURL'];
    imgURL = json['imgURL'];
    cryURL = json['cryURL'];
    habitat = json['habitat'] != null ? new Habitat.fromJson(json['habitat']) : null;
    species = json['species'] != null ? new Species.fromJson(json['species']) : null;
    if (json['poketypes'] != null) {poketypes = <Poketypes>[];
      json['poketypes'].forEach((v) {poketypes!.add(new Poketypes.fromJson(v));
      }
      );
    }
    evolution = json['evolution'] != null
        ? new Pokemon.fromJson(json['evolution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pokemonId'] = this.pokemonId;
    data['name'] = this.name;
    data['color'] = this.color;
    data['thumbURL'] = this.thumbURL;
    data['imgURL'] = this.imgURL;
    data['cryURL'] = this.cryURL;
    if (this.habitat != null) {
      data['habitat'] = this.habitat!.toJson();}
    if (this.species != null) {
      data['species'] = this.species!.toJson();}
    if (this.poketypes != null) {
      data['poketypes'] = this.poketypes!.map((v) => v.toJson()).toList();}
    return data;
  }
}
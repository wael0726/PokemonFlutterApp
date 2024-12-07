import 'Habitat.dart';
import 'Pokemon.dart';
import 'Poketypes.dart';
import 'Species.dart';

class Detail {int? pokemonId;String? name;String? imgURL;String? color;int? hp;int? attack;int? defense;int ? specialattack;int ? specialdefense;int? speed;double? height;double? weight;Habitat? habitat;Species? species;List<Poketypes>? poketypes;Pokemon? evolution;

  Detail(
      {this.pokemonId, this.name, this.imgURL, this.color, this.hp, this.attack, this.defense, this.specialattack, this.specialdefense, this.speed, this.height, this.weight, this.habitat, this.species, this.poketypes, this.evolution});

  Detail.fromJson(Map<String, dynamic> json) {
    pokemonId = json['pokemonId'];
    name = json['name'];
    imgURL = json['imgURL'];
    color = json['color'];
    hp = json['hp'];
    attack = json['attack'];
    defense = json['defense'];
    specialattack = json['specialattack'];
    specialdefense = json['specialdefense'];
    speed = json['speed'];
    weight = json['weight'];
    height = json['height'];
    habitat = json['habitat'] != null ? new Habitat.fromJson(json['habitat']) : null;
    species = json['species'] != null ? new Species.fromJson(json['species']) : null;
    if (json['poketypes'] != null) {poketypes = <Poketypes>[];
      json['poketypes'].forEach((v) {poketypes!.add(new Poketypes.fromJson(v));
      });
    }
    evolution = json['evolution'] != null
        ? new Pokemon.fromJson(json['evolution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pokemonId'] = this.pokemonId;
    data['name'] = this.name;
    data['imgURL'] = this.imgURL;
    data['color'] = this.color;
    data['hp'] = this.hp;
    data['attack'] = this.attack;
    data['defense'] = this.defense;
    data['specialattack'] = this.specialattack;
    data['specialdefense'] = this.specialdefense;
    data['speed'] = this.speed;
    data['weight'] = this.weight;
    data['height'] = this.height;
    if (this.habitat != null) {
      data['habitat'] = this.habitat!.toJson();}
    if (this.species != null) {
      data['species'] = this.species!.toJson();}
    if (this.poketypes != null) {
      data['poketypes'] = this.poketypes!.map((v) => v.toJson()).toList();}
    if (this.evolution != null) {
      data['evolution'] = this.evolution!.toJson();}
    return data;
  }
}
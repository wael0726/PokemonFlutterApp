import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'DetailPage.dart';
import 'Pokemon.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomePageState();
}

class HomePageState extends State<Home> {
  Future<List<Pokemon>>? pokemonList;

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse("https://pokemonsapi.herokuapp.com/pokemons"));

    if (response.statusCode == 200) {
      final List t = json.decode(response.body);
      return t.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors de la recuperation des pokémons');
    }
  }

  @override
  void initState() {
    super.initState();
    pokemonList = fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: FutureBuilder<List<Pokemon>>(
          future: pokemonList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final pokemon = snapshot.data![index];
                  return GestureDetector(
                    onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailPage(pokemonId: pokemon.pokemonId),
                        ),
                      )
                    },
                    child: Card(
                      color: pokemon.color != null ? hexToColor(pokemon.color!) : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (pokemon.imgURL != null)
                            Image.network(pokemon.imgURL!, height: 400 ),
                          Text(
                            pokemon.name ?? 'Unknown',
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text('Habitat: ${pokemon.habitat?.name}',style: const TextStyle(fontSize: 20)),
                          Text('Species: ${pokemon.species?.name}',style: const TextStyle(fontSize: 20)),
                          Text('poketypes: ${pokemon.poketypes!.map((type) => type.name).join(', ')}',style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const SizedBox(width: 0, height: 0);
          },
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';
import 'Pokemon.dart';
import 'DetailPage.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Future<List<Pokemon>>? favoritePokemons;
  Future<List<Pokemon>> fetchFavoritePokemons() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      throw Exception('Utilisateur non connecté');
    }

    final url = Uri.parse("https://pokemonsapi.herokuapp.com/favorites");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des Pokémon favoris');
    }
  }

  @override
  void initState() {
    super.initState();
    favoritePokemons = fetchFavoritePokemons();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: FutureBuilder<List<Pokemon>>(
          future: favoritePokemons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Aucun Pokémon favori trouvé.');
            } else {
              final pokemons = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemons[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(pokemonId: pokemon.pokemonId),
                        ),
                      );
                    },
                    child: Card(
                      color: pokemon.color != null
                          ? hexToColor(pokemon.color!)
                          : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (pokemon.imgURL != null)
                            Image.network(pokemon.imgURL!, height: 300 ),
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
            }
          },
        ),
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}



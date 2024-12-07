import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';
import 'details.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.pokemonId});
  final int? pokemonId;
  @override
  State<DetailPage> createState() => DetailState();}
class DetailState extends State<DetailPage> {
  Future<Detail>? detailPokemon;
  bool isFavorite = false;
  Future<void> _checkIfFavorite() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      setState(() {
        isFavorite = false;});
      return;}
    final url = Uri.parse(
        "https://pokemonsapi.herokuapp.com/favorite?pokemonId=${widget.pokemonId}");
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',},);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isFavorite = data['isFavorite'] ?? false;});
      } else {
        print(
            'Erreur lors de la vérification des favoris : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la vérification des favoris : $e');
    }
  }
  Future<void> _toggleFavorite() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez vous connecter pour gérer les favoris')),);
      return;}
    final url = Uri.parse(
        "https://pokemonsapi.herokuapp.com/favorite?pokemonId=${widget.pokemonId}");
    try {
      final response = isFavorite
          ? await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },)
          : await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',},);
      if (response.statusCode == 200) {
        setState(() {
          isFavorite = !isFavorite;});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFavorite
                ? 'Ajouté aux favoris avec succès'
                : 'Supprimé des favoris avec succès'),),);
      } else {
        print('Erreur lors de la gestion des favoris : ${response.statusCode}');
      }
    } catch (e) {print('Erreur réseau lors de la gestion des favoris : $e');}
  }
  Future<Detail> fetchPokemons() async {
    final response = await http.get(Uri.parse(
        "https://pokemonsapi.herokuapp.com/pokemon?pokemonId=${widget.pokemonId}"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Detail.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Échec du chargement des données');
    }
  }
  @override
  void initState() {
    super.initState();
    detailPokemon = fetchPokemons();
    _checkIfFavorite();
  }
  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        Provider.of<AuthProvider>(context, listen: false).token != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail du Pokémon"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: FutureBuilder<Detail>(
          future: detailPokemon,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (snapshot.hasData) {
              Detail pokemon = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(pokemon.imgURL ?? '', height: 200),
                    Text(
                      pokemon.name ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 16),
                    Text("HP: ${pokemon.hp}"),
                    Text("Attack: ${pokemon.attack}"),
                    Text("Defense: ${pokemon.defense}"),
                    Text("Special Attack: ${pokemon.specialattack}"),
                    Text("Special Defense: ${pokemon.specialdefense}"),
                    Text("Speed: ${pokemon.speed}"),
                    Text("Height: ${pokemon.height}"),
                    Text("Weight: ${pokemon.weight}"),
                    const SizedBox(height: 20),
                    if (pokemon.evolution != null ||
                        pokemon.evolution?.evolution != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (pokemon.evolution != null)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      pokemonId: pokemon.evolution!.pokemonId,),
                                  ),
                                );
                              },
                              child: Image.network(
                                pokemon.evolution!.imgURL ?? '',
                                height: 100,),
                            ),
                          if (pokemon.evolution?.evolution != null) ...[
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      pokemonId: pokemon.evolution!.evolution!
                                          .pokemonId,),
                                  ),
                                );
                              },
                              child: Image.network(
                                pokemon.evolution!.evolution!.imgURL ?? '',
                                height: 100,),
                            ),
                          ],
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (isLoggedIn)
                      ElevatedButton(
                        onPressed: _toggleFavorite,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isFavorite ? Colors.red : Colors.green,
                        ),
                        child: Text(
                          isFavorite
                              ? 'Supprimer des favoris'
                              : 'Ajouter aux favoris',),
                      )
                    else
                      const Text(
                        'Connectez-vous pour intéragir',
                        style: TextStyle(color: Colors.grey),),
                  ],
                ),
              );
            } else {
              return const Text("Aucun détail trouvé.");
            }
          },
        ),
      ),
    );
  }
}

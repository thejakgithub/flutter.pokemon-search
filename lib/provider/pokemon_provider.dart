import 'package:flutter/material.dart';
import 'package:pokemon_search/models/pokemonAll.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:pokemon_search/services/service.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonInfo pokemonInfo = PokemonInfo();
  PokemonAll pokemonAll =
      PokemonAll(count: 0, next: '', previous: '', results: []);

  Future<void> getPokemonInfo(String name) async {
    pokemonInfo = await Service().getPokemonInfo(name);
    notifyListeners();
  }

  Future<void> getPokemonAll() async {
    pokemonAll = await Service().getPokemonAll();
    notifyListeners();
  }
}

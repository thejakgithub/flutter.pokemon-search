import 'package:flutter/material.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:pokemon_search/services/service.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonInfo pokemonInfo = PokemonInfo();

  Future<void> getPokemonInfo(String name) async {
    pokemonInfo = await Service().getPokemonInfo(name);
    notifyListeners();
  }
}

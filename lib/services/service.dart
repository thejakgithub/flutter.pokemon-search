import 'package:pokemon_search/api.dart';
import 'package:pokemon_search/models/pokemonAll.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';

class Service {
  static final _singleton = Service._internal();
  factory Service() => _singleton;

  Service._internal();

  Future<PokemonInfo> getPokemonInfo(String name) async {
    try {
      var response = await Api().dio.get<String>('/pokemon/$name');
      return pokemonInfoFromJson(response.data ?? "");
    } catch (e) {
      return PokemonInfo();
    }
  }

  Future<PokemonAll> getPokemonAll() async {
    try {
      var response =
          await Api().dio.get<String>('/pokemon?limit=100000&offset=0');
      return pokemonAllFromJson(response.data ?? "");
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:pokemon_search/api.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';

class Service {
  static final _singleton = Service._internal();
  factory Service() => _singleton;

  Service._internal();

  Future<PokemonInfo> getPokemonInfo(String name) async {
    var response = await Api().dio.get<String>('/pokemon/$name');

    return pokemonInfoFromJson(response.data ?? "");
  }
}

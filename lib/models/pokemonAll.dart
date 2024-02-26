// To parse this JSON data, do
//
//     final pokemonAll = pokemonAllFromJson(jsonString);

import 'dart:convert';

PokemonAll pokemonAllFromJson(String str) =>
    PokemonAll.fromJson(json.decode(str));

String pokemonAllToJson(PokemonAll data) => json.encode(data.toJson());

class PokemonAll {
  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  PokemonAll({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonAll.fromJson(Map<String, dynamic> json) => PokemonAll(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String name;
  String url;

  Result({
    required this.name,
    required this.url,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

import 'package:flutter/material.dart';
import 'package:pokemon_search/colors/colors.dart';
import 'package:pokemon_search/extension/extension.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class PokemonDetailScreen extends StatefulWidget {
  PokemonDetailScreen({
    super.key,
    required this.pokemonInfo,
  });

  PokemonInfo pokemonInfo = PokemonInfo();

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  String getNumberPokemon(int id) {
    String number = "";
    if (id < 10) {
      number = "#000$id";
    } else if (id < 100) {
      number = "#00$id";
    } else if (id < 1000) {
      number = "#0$id";
    } else {
      number = "#$id";
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 0),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);

                FocusScope.of(context).unfocus();
              },
            ),
            backgroundColor: Colors.transparent,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.pokemonInfo.name!.capitalize(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  getNumberPokemon(widget.pokemonInfo.id!),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xff616161),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? MediaQuery.of(context).size.width * 0.2 : 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: widget.pokemonInfo.id!,
                child: Center(
                  child: Image.network(
                    height: 250,
                    widget.pokemonInfo.sprites!.other!.officialArtwork!
                        .frontDefault!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    "Height",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.pokemonInfo.height! / 10} M",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Text(
                    "Weight",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.pokemonInfo.weight! / 10} Kg",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Stats",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(
                height: 5,
              ),
              for (var data in widget.pokemonInfo.stats!)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data.stat!.name!.capitalize(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: data.baseStat! / 100,
                        color: Colors.blueAccent,
                        backgroundColor: Colors.blueAccent.withOpacity(0.2),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),

              const Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var data in widget.pokemonInfo.types!)
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(colors[data.type!.name!]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              data.type!.name!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Abilities",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var data in widget.pokemonInfo.abilities!)
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(colors["normal"]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              data.ability!.name!.capitalize(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              // Move
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Moves",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var data in widget.pokemonInfo.moves!)
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(colors["normal"]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              data.move!.name!.capitalize(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SafeArea(
                child: SizedBox(
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

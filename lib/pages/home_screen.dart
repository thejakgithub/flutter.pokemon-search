import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokemon_search/main.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:pokemon_search/provider/pokemon_provider.dart';
import 'package:pokemon_search/services/service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> colors = {
    "normal": '#A8A77A',
    "fire": '#EE8130',
    "water": '#6390F0',
    "electric": '#F7D02C',
    "grass": '#7AC74C',
    "ice": '#96D9D6',
    "fighting": '#C22E28',
    "poison": '#A33EA1',
    "ground": '#E2BF65',
    "flying": '#A98FF3',
    "psychic": '#F95587',
    "bug": '#A6B91A',
    "rock": '#B6A136',
    "ghost": '#735797',
    "dragon": '#6F35FC',
    "dark": '#705746',
    "steel": '#B7B7CE',
    "fairy": '#D685AD',
  };

  bool isSearch = false;

  bool isValue = false;
  bool isLoading = false;
  String pokemonName = "";
  late PokemonInfo pokemonInfo = PokemonInfo();

  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  void getPokemonInfo(String name) async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<PokemonProvider>(context, listen: false)
        .getPokemonInfo(name)
        .then((_) {
      var response =
          Provider.of<PokemonProvider>(context, listen: false).pokemonInfo;

      setState(() {
        isSearch = true;
        pokemonInfo = response;
        isLoading = false;
      });
    });
  }

  void clearInputSearch() {
    setState(() {
      searchCtrl.clear();
      isValue = false;
    });
  }

  Widget _resultSearch() {
    if (pokemonInfo.name == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 150),
          child: Text(
            "ไม่พบข้อมูล Pokemon",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Image.network(
            height: 250,
            pokemonInfo.sprites!.other!.officialArtwork!.frontDefault!,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 30,
          ),
          Wrap(
            spacing: 10,
            children: [
              for (var data in pokemonInfo.types!)
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: HexColor.fromHex(colors[data.type!.name!]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
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
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color(0xfff4f4f4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Image.asset(
                      "assets/images/logo-pokemon.png",
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: isValue
                            ? IconButton(
                                onPressed: () {
                                  clearInputSearch();
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        labelText: 'กรอกชื่อ Pokemon',
                      ),
                      onChanged: (value) {
                        if (value == "") {
                          setState(() {
                            isValue = false;
                          });
                        } else {
                          setState(() {
                            isValue = true;
                          });
                        }
                      },
                      onSubmitted: (value) => getPokemonInfo(value),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => getPokemonInfo(searchCtrl.text),
                        child: const Text(
                          "ค้นหา",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      ),
                    if (isSearch && !isLoading) _resultSearch()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

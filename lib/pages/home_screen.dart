import 'package:flutter/material.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:pokemon_search/services/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearch = false;
  String pokemonName = "";
  late PokemonInfo pokemonInfo = PokemonInfo();

  TextEditingController searchCtrl = TextEditingController();

  Widget _resultSearch() {
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
        Wrap(
          spacing: 10,
          children: [
            for (var data in pokemonInfo.types!)
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        data.type!.name!.toUpperCase(),
                        style: TextStyle(
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

  @override
  void initState() {
    super.initState();
  }

  void getPokemonInfo(String name) async {
    var response = await Service().getPokemonInfo(name);

    setState(() {
      isSearch = true;
      pokemonInfo = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      labelText: 'กรอกชื่อ Pokemon',
                    ),
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
                  if (isSearch) _resultSearch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_search/colors/colors.dart';
import 'package:pokemon_search/extension/extension.dart';
import 'package:pokemon_search/models/pokemonAll.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:pokemon_search/provider/pokemon_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearch = false;
  bool isValue = false;
  bool isLoading = false;
  bool isSelected = false;
  bool isConnection = true;
  List<Result> pokemonList = [];
  List<Result> filterList = [];
  late PokemonInfo pokemonInfo = PokemonInfo();

  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });

    if (kIsWeb) {
      getPokemonAll();
    } else {
      checkConnection();
      getPokemonAll();

      Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        checkConnection();
        getPokemonAll();
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnection = false;
      });
    } else {
      setState(() {
        isConnection = true;
      });
    }
  }

  Future<void> getPokemonAll() async {
    await Provider.of<PokemonProvider>(context, listen: false)
        .getPokemonAll()
        .then((value) {
      PokemonAll response =
          Provider.of<PokemonProvider>(context, listen: false).pokemonAll;
      setState(() {
        pokemonList = response.results;
      });
    });
  }

  void filterPokemonList(String name) {
    setState(() {
      filterList = pokemonList
          .where((element) => element.name.startsWith(name))
          .toList();
    });
  }

  void searchPokemon(String name) {
    if (name == "") {
      setState(() {
        isSelected = true;
        isValue = false;
      });
    } else {
      setState(() {
        isSelected = false;
        isValue = true;
      });
    }
    filterPokemonList(name);
  }

  double? get calHeightFilterSearch {
    if (filterList.length > 5) {
      return 58.00 * 5;
    } else {
      return null;
    }
  }

  Future<void> getPokemonInfo(String name) async {
    FocusScope.of(context).unfocus();
    setState(() {
      searchCtrl.text = name;
      isLoading = true;
      isSearch = true;
      isSelected = true;
    });
    await Provider.of<PokemonProvider>(context, listen: false)
        .getPokemonInfo(name.toLowerCase())
        .then((_) {
      PokemonInfo response =
          Provider.of<PokemonProvider>(context, listen: false).pokemonInfo;

      setState(() {
        pokemonInfo = response;
        isLoading = false;
      });
    });
  }

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 50,
          ),
          Hero(
            tag: pokemonInfo.id!,
            child: GestureDetector(
              onTap: () {
                context.pushNamed("pokemon_detail", extra: pokemonInfo);
              },
              child: Center(
                child: Image.network(
                  height: 250,
                  pokemonInfo.sprites!.other!.officialArtwork!.frontDefault!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              getNumberPokemon(pokemonInfo.id!),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              pokemonInfo.name!.capitalize(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var data in pokemonInfo.types!)
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
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          isSelected = true;
        });
      },
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        child: Scaffold(
          backgroundColor: const Color(0xfff4f4f4),
          body: Center(
            child: Container(
              height: double.infinity,
              width: 430,
              color: const Color(0xfff4f4f4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
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
                                searchPokemon(value);
                              },
                              onTap: () {
                                setState(() {
                                  isSelected = false;
                                });
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
                                onPressed: () =>
                                    getPokemonInfo(searchCtrl.text),
                                child: const Text(
                                  "ค้นหา",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            if (isLoading && isConnection)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 150),
                                  child: CircularProgressIndicator(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            if (isSearch && !isLoading && isConnection)
                              _resultSearch()
                            else if (!isConnection)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  const Icon(
                                    Icons.wifi_off,
                                    size: 100,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "ไม่มีการเชื่อมต่ออินเทอร์เน็ต",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (!isSelected &&
                          isValue &&
                          filterList.isNotEmpty &&
                          isConnection)
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 250,
                          child: Container(
                            height: calHeightFilterSearch,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                for (var data in filterList)
                                  ListTile(
                                    title: Text(
                                      data.name.capitalize(),
                                    ),
                                    onTap: () => getPokemonInfo(data.name),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

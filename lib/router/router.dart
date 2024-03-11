import 'package:flutter/material.dart';
import 'package:pokemon_search/models/pokemonInfo.dart';
import 'package:pokemon_search/pages/home_screen.dart';
import 'package:pokemon_search/pages/pokemon_detail_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/pokemon_detail',
      name: 'pokemon_detail',
      pageBuilder: (context, state) {
        // fade transition animation
        return CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: PokemonDetailScreen(
              pokemonInfo: state.extra as PokemonInfo,
            ));
      },
      // builder: (context, state) => PokemonDetailScreen(
      //   pokemonInfo: state.extra as PokemonInfo,
      // ),
    ),
  ],
);

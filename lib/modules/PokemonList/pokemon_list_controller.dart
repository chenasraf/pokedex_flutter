import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:provider/provider.dart';

import '../../core/models/pokemon.dart';

class PokemonListController extends ChangeNotifier {
  bool loading = false;
  Iterable<Pokemon> pokemonList = [];

  PokemonListController() {
    debugPrint('PokemonListController()');
    getPokemon();
  }

  static PokemonListController of(BuildContext context) =>
      Provider.of<PokemonListController>(context, listen: false);

  Future<void> getPokemon() async {
    debugPrint('getPokemon()');
    loading = true;
    await Future.microtask(() => pokemonList = getAllPokemon().values);
    loading = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:pokemon_api/pokemon_api.dart';
import 'package:provider/provider.dart';

class PokemonListController extends ChangeNotifier {
  bool loading = false;
  List<Pokemon> pokemonList = [];
  Map<String, Pokemon> pokemonMap = {};
  List<PokemonSpecies> speciesList = [];
  Map<String, PokemonSpecies> speciesMap = {};

  PokemonListController() {
    debugPrint('PokemonListController()');
    getPokemon();
  }

  static PokemonListController of(BuildContext context) => Provider.of<PokemonListController>(context, listen: false);

  Future<void> getPokemon() async {
    debugPrint('getPokemon()');
    loading = true;
    final pokemonListResources = await PokemonAPIClient.instance.getPokemonList(PageOptions(), maxPages: null);
    final pokemonSpeciesListResources =
        await PokemonAPIClient.instance.getPokemonSpeciesList(PageOptions(), maxPages: null);

    final pokemonFutures = <Future<Pokemon>>[];
    final speciesFutures = <Future<PokemonSpecies>>[];

    var i = 0;
    for (final resource in pokemonListResources) {
      pokemonFutures.add(resource.get());
      if (i < pokemonSpeciesListResources.length) {
        speciesFutures.add(pokemonSpeciesListResources[i].get());
      }

      if (pokemonFutures.length == 5) {
        await Future.wait([
          Future.wait(pokemonFutures).then((value) => pokemonList.addAll(value)),
          Future.wait(speciesFutures).then((value) => speciesList.addAll(value)),
        ]);
        pokemonFutures.clear();
        speciesFutures.clear();
      }
      i++;
    }

    if (pokemonFutures.isNotEmpty) {
      await Future.wait(pokemonFutures).then((value) => pokemonList.addAll(value));
    }

    if (speciesFutures.isNotEmpty) {
      await Future.wait(speciesFutures).then((value) => speciesList.addAll(value));
    }

    pokemonMap = Map.fromEntries(pokemonList.map((e) => MapEntry(e.name, e)));
    speciesMap = Map.fromEntries(speciesList.map((e) => MapEntry(e.name, e)));
    loading = false;
    notifyListeners();
  }
}

class ProgressReporter {
  final int total;
  int count = 0;
  ProgressReporter(this.total);

  void increment() {
    count++;
    debugPrint('ProgressReporter: $count/$total');
  }

  bool get isDone => count >= total;

  double get progress => count / total;
}


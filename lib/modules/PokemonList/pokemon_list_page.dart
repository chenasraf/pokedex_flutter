import 'package:flutter/material.dart';
import 'package:pokedex/modules/PokemonList/pokemon_list_controller.dart';
import 'package:provider/provider.dart';

import '../../core/models/pokemon.dart';
import '../../widgets/pokemon_list_item.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late Iterable<Pokemon> filtered;
  late TextEditingController search;
  bool searching = false;
  bool afterInit = false;

  @override
  void initState() {
    super.initState();
    search = TextEditingController(text: '');
    filtered = _applyFilters(ctrl.pokemonList);
    afterInit = ctrl.pokemonList.isNotEmpty;
    search.addListener(_searchListener);

    if (!afterInit) {
      PokemonListController.of(context).addListener(() {
        if (afterInit) {
          return;
        }
        if (ctrl.pokemonList.isNotEmpty) {
          afterInit = true;
          setState(() {
            filtered = _applyFilters(ctrl.pokemonList);
          });
        }
      });
    }
  }

  void _searchListener() {
    debugPrint('searching: ${search.text}');
    setState(() {
      filtered = _applyFilters(ctrl.pokemonList);
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  PokemonListController get ctrl => PokemonListController.of(context);

  Iterable<Pokemon> _applyFilters(Iterable<Pokemon> list) =>
      list.where((poke) => [poke.displayName, poke.formName]
          .join(' ')
          .toLowerCase()
          .contains(search.text.toLowerCase()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: searching
              ? TextField(
                  controller: search,
                  decoration: const InputDecoration(hintText: 'Search by name'),
                  autofocus: true,
                )
              : const Text('Pokedex')),
      floatingActionButton: FloatingActionButton(
        // child: const Icon(Icons.catching_pokemon),
        child: const Icon(Icons.search),
        onPressed: () => setState(() => searching = !searching),
      ),
      body: Consumer<PokemonListController>(
        builder: (context, ctrl, child) {
          if (ctrl.loading) {
            return const Center(
              child: SizedBox.square(
                dimension: 150,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) => PokemonListItem(
              poke: filtered.elementAt(index),
            ),
          );
        },
      ),
    );
  }
}

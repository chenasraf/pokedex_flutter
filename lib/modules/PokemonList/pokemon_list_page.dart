import 'package:flutter/material.dart';
import 'package:pokedex/core/models/pokemon_helper.dart';
import 'package:pokedex/modules/PokemonList/pokemon_list_controller.dart';
import 'package:pokemon_api/pokemon_api.dart';
import 'package:provider/provider.dart';

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

  PokemonListController get ctrl => PokemonListController.of(context);

  @override
  void initState() {
    super.initState();
    search = TextEditingController(text: '');
    filtered = _applyFilters(ctrl.pokemonList);
    afterInit = ctrl.pokemonList.isNotEmpty;
    search.addListener(_searchListener);

    PokemonListController.of(context).addListener(() {
      if (ctrl.pokemonList.isNotEmpty) {
        afterInit = true;
        setState(() {
          filtered = _applyFilters(ctrl.pokemonList);
        });
      }
    });
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

  Iterable<Pokemon> _applyFilters(Iterable<Pokemon> list) => list.where((poke) {
        final species = ctrl.speciesMap[poke.species.name];
        return [
          species != null ? PokemonHelper.displayName(poke, species) : null,
          species != null ? PokemonHelper.formName(poke, species) : null,
          poke.name,
        ].whereType<String>().join(' ').toLowerCase().contains(search.text.toLowerCase());
      }).toList()
        ..sort((a, b) {
          final ao = a.order == -1 ? a.id : a.order;
          final bo = b.order == -1 ? b.id : b.order;
          return ao.compareTo(bo);
        });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searching
            ? TextField(
                controller: search,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  suffixIcon: search.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => search.clear(),
                        )
                      : null,
                ),
                autofocus: true,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pokedex'),
                  if (ctrl.loading)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () => setState(() => searching = !searching),
      ),
      body: Consumer<PokemonListController>(
        builder: (context, ctrl, child) {
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


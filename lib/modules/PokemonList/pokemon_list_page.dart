import 'package:flutter/material.dart';
import 'package:pokedex/data/pokemon.dart';
import 'package:pokedex/modules/PokemonList/pokemon_list_controller.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokedex')),
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
            itemCount: ctrl.pokemonList.length,
            itemBuilder: (context, index) {
              final poke = ctrl.pokemonList.elementAt(index);
              return Card(
                child: ListTile(
                  leading: poke.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: poke.imageUrl!,
                          width: 64,
                          height: 64,
                          progressIndicatorBuilder: (context, url, progress) =>
                              const SizedBox.square(
                            dimension: 64,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const SizedBox.square(dimension: 64),
                  title: Text(poke.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

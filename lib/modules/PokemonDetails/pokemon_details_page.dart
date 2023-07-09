import 'package:flutter/material.dart';
import 'package:pokedex/core/models/pokemon_helper.dart';
import 'pokemon_details_args.dart';
import '../PokemonList/pokemon_list_controller.dart';
import '../../widgets/pokemon_image.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({super.key});

  PokemonDetailsArgs argsOf(BuildContext context) => PokemonDetailsArgs.of(context);

  @override
  Widget build(BuildContext context) {
    final ctrl = PokemonListController.of(context);
    final args = argsOf(context);
    final poke = ctrl.pokemonMap[args.name]!;
    final species = ctrl.speciesMap[poke.species.name]!;

    final children = <Widget Function()>[
      () => Text(PokemonHelper.displayName(species)),
      () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'pokemon-${poke.name}',
                child: PokemonImage(poke: poke, size: 250),
              ),
              PokemonImage(poke: poke, size: 250, shiny: true),
            ],
          ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(PokemonHelper.displayName(species)),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => children[index].call(),
        itemCount: children.length,
      ),
    );
  }
}


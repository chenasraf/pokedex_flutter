import 'package:flutter/material.dart';
import 'pokemon_details_args.dart';
import '../PokemonList/pokemon_list_controller.dart';
import '../../widgets/pokemon_image.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = PokemonListController.of(context);
    final poke = ctrl.pokemonMap[PokemonDetailsArgs.of(context).name]!;

    final children = <Widget Function()>[
      () => Text(poke.displayName),
      () => PokemonImage(poke: poke, size: 250),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(poke.displayName),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => children[index].call(),
        itemCount: children.length,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pokedex/core/models/pokemon_helper.dart';
import 'package:pokedex/core/routes.dart';
import 'package:pokedex/core/utils/extensions/string_extensions.dart';
import 'package:pokedex/modules/PokemonDetails/pokemon_details_args.dart';
import 'package:pokemon_api/pokemon_api.dart';

import '../modules/PokemonList/pokemon_list_controller.dart';
import 'pokemon_image.dart';

class PokemonListItem extends StatelessWidget {
  const PokemonListItem({
    super.key,
    required this.poke,
  });

  final Pokemon poke;

  @override
  Widget build(BuildContext context) {
    final species = PokemonListController.of(context).speciesMap[poke.species.name];
    print('poke: ${poke.name}, species: ${species?.name}');
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.pokemonDetails,
          arguments: PokemonDetailsArgs(name: poke.name),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8).copyWith(top: 0),
              child: Hero(
                tag: 'pokemon-${poke.name}',
                child: PokemonImage(poke: poke, size: 64),
                // child: poke != null
                //     ? PokemonImage(poke: poke, size: 64)
                //     : const SizedBox.square(dimension: 64, child: Placeholder()),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              [
                species != null ? PokemonHelper.displayName(species) : poke.name.capitalize(),
                species != null && PokemonHelper.formName(poke, species) != null ? '(${PokemonHelper.formName(poke, species)})' : null,
              ].whereType<String>().join(' '),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}


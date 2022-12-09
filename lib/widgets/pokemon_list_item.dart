import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/modules/PokemonDetails/pokemon_details_args.dart';

import '../core/models/pokemon.dart';
import '../core/routes.dart';
import 'pokemon_image.dart';

class PokemonListItem extends StatelessWidget {
  const PokemonListItem({
    super.key,
    required this.poke,
  });

  final Pokemon poke;

  @override
  Widget build(BuildContext context) {
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
              child: poke.imageUrl != null
                  ? SizedBox.square(
                      dimension: 64,
                      child: PokemonImage(poke: poke, size: 64),
                    )
                  : const SizedBox.square(dimension: 64),
            ),
            const SizedBox(width: 8),
            Text(
              [
                poke.displayName,
                poke.formName != null ? '(${poke.formName})' : null,
              ].whereType<String>().join(' '),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

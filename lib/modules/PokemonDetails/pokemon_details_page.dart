import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_api/pokemon_api.dart';
import '../../core/models/pokemon_helper.dart';
import '../../core/utils/extensions/string_extensions.dart';
import '../../widgets/pokemon_move.dart';
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
    final imgSize = 96.0;

    final levelMoves = poke.moves
        .where((move) => move.versionGroupDetails.any((det) => det.moveLearnMethod?.name == 'level-up'))
        .toList()
      ..sort((a, b) => (a.versionGroupDetails
                  .firstWhere((det) => det.moveLearnMethod?.name == 'level-up')
                  .levelLearnedAt ??
              99)
          .compareTo(
              b.versionGroupDetails.firstWhere((det) => det.moveLearnMethod?.name == 'level-up').levelLearnedAt ?? 99));

    final tmMoves = poke.moves
        .where((move) => move.versionGroupDetails.any((det) => det.moveLearnMethod?.name == 'machine'))
        .toList()
      ..sort((a, b) => a.move?.name.compareTo(b.move?.name ?? "") ?? 1);

    final children = <Widget Function()>[
      () => Text(PokemonHelper.displayName(poke, species)),
      () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'pokemon-${poke.name}',
                child: PokemonImage(poke: poke, size: imgSize),
              ),
              PokemonImage(poke: poke, size: imgSize, shiny: true),
            ],
          ),
      () => const Text('Weaknesses', textScaleFactor: 1.2),
      () => FutureBuilder(
            future: Future.wait(poke.types.map((t) => t.type.get())),
            builder: (context, snapshot) {
              final data = snapshot.hasData
                  ? snapshot.data!
                      .toList()
                      .fold(<NamedAPIResource>[], (prev, type) => prev..addAll(type.damageRelations.doubleDamageFrom))
                  : <NamedAPIResource>[];
              return Wrap(
                children: [
                  for (final weakness in data)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Chip(
                        label: Text('${weakness.name.capitalize()} x2'),
                      ),
                    )
                ],
              );
            },
          ),
      () => const Text('Abilities', textScaleFactor: 1.2),
      () => Wrap(
            children: [
              for (final ability in poke.abilities)
                FutureBuilder(
                  future: ability.ability.get(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Chip(
                        label: Text(snapshot.data?.name.capitalize() ?? '...'),
                      ),
                    );
                  },
                ),
            ],
          ),
      () => const Text('Moves', textScaleFactor: 1.2),
      () => const Text('Level Moves', textScaleFactor: 1.2),
      () => LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                children: [
                  for (final move in levelMoves)
                    FutureBuilder(
                      future: move.move?.get(),
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: constraints.maxWidth / 2,
                          child: PokemonMoveCard.level(
                            move: snapshot.data,
                            versionDetails: move.versionGroupDetails,
                            loading: !snapshot.hasData,
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
      () => const SizedBox(height: 16),
      () => const Text('TM Moves', textScaleFactor: 1.2),
      () => LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                children: [
                  for (final move in tmMoves)
                    FutureBuilder(
                      future: move.move?.get(),
                      builder: (context, snapshot) {
                        return SizedBox(
                          width: constraints.maxWidth / 2,
                          child: PokemonMoveCard.tm(
                            move: snapshot.data,
                            versionDetails: move.versionGroupDetails,
                            loading: !snapshot.hasData,
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
      () => Text('Order: ${poke.order}'),
      () => SelectableText('img: ${PokemonHelper.imageUrl(poke)}')
    ];

    final icon = PokemonHelper.iconImageUrl(poke);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              Container(
                color: Colors.purple,
                child: CachedNetworkImage(
                  imageUrl: icon,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            // const SizedBox(width: 8),
            Text(PokemonHelper.displayName(poke, species)),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => children[index].call(),
        itemCount: children.length,
      ),
    );
  }
}


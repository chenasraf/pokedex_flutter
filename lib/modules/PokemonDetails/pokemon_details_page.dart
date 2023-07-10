import 'package:flutter/material.dart';
import 'package:pokedex/core/models/pokemon_helper.dart';
import 'package:pokedex/core/utils/extensions/string_extensions.dart';
import 'package:pokemon_api/pokemon_api.dart';
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
      () => const Text('Level Moves', textScaleFactor: 1.2),
      ...levelMoves
          .map((move) => () => FutureBuilder(
                future: move.move?.get(),
                builder: (context, snapshot) {
                  final versionDet =
                      move.versionGroupDetails.firstWhere((det) => det.moveLearnMethod?.name == 'level-up');
                  final moveName = snapshot.hasData && snapshot.data is Move
                      ? PokemonHelper.getMoveName(snapshot.data as Move)
                      : move.move?.name.capitalize();
                  final level = versionDet.levelLearnedAt;
                  return Text('$moveName (Lv. $level)');
                },
              ))
          .toList(),
      () => const SizedBox(height: 16),
      () => const Text('TM Moves', textScaleFactor: 1.2),
      ...tmMoves
          .map((move) => () => FutureBuilder(
                future: move.move?.get(),
                builder: (context, snapshot) {
                  final moveName = snapshot.hasData
                      ? PokemonHelper.getMoveName(snapshot.data as Move)
                      : move.move?.name.capitalize() ?? "Unknown Move";
                  return Text(moveName);
                },
              ))
          .toList(),
      () => Text('Order: ${poke.order}'),
      () => SelectableText('img: ${PokemonHelper.imageUrl(poke)}')
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(PokemonHelper.displayName(poke, species)),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => children[index].call(),
        itemCount: children.length,
      ),
    );
  }
}


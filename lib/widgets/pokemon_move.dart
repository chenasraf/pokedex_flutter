import 'package:flutter/material.dart';
import '../core/models/pokemon_helper.dart';
import '../core/utils/extensions/iterable_extensions.dart';
import '../core/utils/extensions/string_extensions.dart';
import 'package:pokemon_api/pokemon_api.dart';

enum MoveType { level, tm }

class PokemonMoveCard extends StatelessWidget {
  // const PokemonMoveCard._({super.key, required this.move, required this.moveType});

  const PokemonMoveCard.level({
    super.key,
    required this.move,
    required this.versionDetails,
    required this.loading,
  }) : moveType = MoveType.level;

  const PokemonMoveCard.tm({
    super.key,
    required this.move,
    required this.versionDetails,
    required this.loading,
  }) : moveType = MoveType.tm;

  final Move? move;
  final MoveType moveType;
  final List<PokemonMoveVersion> versionDetails;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading || move == null) {
      return Card(
        child: Column(
          children: [
            Text(move?.name.capitalize() ?? '...'),
            const Text('...'),
          ],
        ),
      );
    }
    final details = versionDetails.firstWhereOrNull((det) => det.moveLearnMethod?.name == 'level-up');
    return Card(
      child: Column(
        children: [
          Text(PokemonHelper.getMoveName(move!)),
          // Text(PokemonHelper.getMoveDescription(move!)),
          moveType == MoveType.level
              ? Text('Level: ${details?.levelLearnedAt ?? '??'}')
              : const Text('TM'),
        ],
      ),
    );
  }
}


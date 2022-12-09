import 'package:flutter/material.dart';

class PokemonDetailsArgs {
  final String name;

  PokemonDetailsArgs({required this.name});

  static PokemonDetailsArgs of(BuildContext context) =>
      ModalRoute.of(context)!.settings.arguments as PokemonDetailsArgs;
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/models/pokemon.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    super.key,
    this.size = 64,
    required this.poke,
  });

  final Pokemon poke;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: poke.imageUrl!,
      width: size,
      height: size,
      progressIndicatorBuilder: (context, url, progress) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

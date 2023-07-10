import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/core/models/pokemon_helper.dart';
import 'package:pokemon_api/pokemon_api.dart';

class PokemonImage extends StatelessWidget {
  const PokemonImage({
    super.key,
    this.size = 64,
    required this.poke,
    this.shiny = false,
  });

  final Pokemon poke;
  final double size;
  final bool shiny;

  @override
  Widget build(BuildContext context) {
    var img = PokemonHelper.imageUrl(poke);
    var shinyImg = PokemonHelper.shinyImageUrl(poke);
    if (img == null) {
      return SizedBox.square(dimension: size, child: const Placeholder());
    }

    return CachedNetworkImage(
      imageUrl: !shiny ? img : shinyImg ?? img,
      width: size,
      height: size,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, progress) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}


import 'package:pokemon_api/pokemon_api.dart';
import 'package:strings/strings.dart' as strings;

import '../utils/extensions/string_extensions.dart';
import '../utils/extensions/iterable_extensions.dart';

class PokemonHelper {
  static String? imageUrl(Pokemon pokemon) =>
      pokemon.sprites.other?.home.frontDefault ??
      pokemon.sprites.frontDefault ??
      pokemon.sprites.versions?.generation8.icons.frontDefault;

  static String? shinyImageUrl(Pokemon pokemon) =>
      pokemon.sprites.other?.home.frontShiny ??
      pokemon.sprites.frontShiny ??
      pokemon.sprites.versions?.generation8.icons.frontShiny;

  static String displayName(PokemonSpecies pokemon) {
    final speciesName = pokemon.names.firstWhereOrNull((n) => n.language.name == 'en')?.name;

    return speciesName != null ? strings.capitalize(speciesName) : pokemon.name.capitalize();
  }

  static String? formName(Pokemon pokemon, PokemonSpecies species) {
    final speciesName = species.name;
    if (speciesName == pokemon.name) {
      return null;
    }
    final form = pokemon.name.split('-').sublist(1).join(' ');
    final presets = {
      'gmax': 'Gygantamax',
      'alola': 'Alolan',
      'galar': 'Galarian',
      'hisui': 'Hisuian',
    };
    return presets[form] ?? form.capitalize();
  }
}

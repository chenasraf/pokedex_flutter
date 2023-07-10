import 'package:pokemon_api/pokemon_api.dart';
import 'package:strings/strings.dart' as strings;

import '../utils/extensions/string_extensions.dart';
import '../utils/extensions/iterable_extensions.dart';

class PokemonHelper {
  static String? imageUrl(Pokemon pokemon) => [
        pokemon.sprites.frontDefault,
        pokemon.sprites.other?.home?.frontDefault,
        pokemon.sprites.versions?.generation8?.icons?.frontDefault,
      ].firstWhereOrNull((url) => url != null);

  static String? shinyImageUrl(Pokemon pokemon) => [
        pokemon.sprites.frontShiny,
        pokemon.sprites.other?.home?.frontShiny,
        pokemon.sprites.versions?.generation8?.icons?.frontShiny,
      ].firstWhereOrNull((url) => url != null);

  static String? iconImageUrl(Pokemon pokemon) => [
        pokemon.sprites.versions?.generation8?.icons?.frontDefault,
        pokemon.sprites.versions?.generation7?.icons?.frontDefault,
        pokemon.sprites.versions?.generation6?.xy?.frontDefault,
        pokemon.sprites.versions?.generation5?.blackWhite?.frontDefault,
        pokemon.sprites.versions?.generation4?.platinum?.frontDefault,
        pokemon.sprites.versions?.generation3?.emerald?.frontDefault,
        pokemon.sprites.versions?.generation2?.crystal?.frontDefault,
        pokemon.sprites.versions?.generation1?.yellow?.frontDefault,
        pokemon.sprites.other?.officialArtwork?.frontDefault,
        pokemon.sprites.other?.home?.frontDefault
      ].firstWhereOrNull((url) => url != null);

  static String displayName(Pokemon pokemon, PokemonSpecies? species) {
    final pokeName = pokemon.name;
    final speciesName = species?.names.firstWhereOrNull((n) => n.language.name == 'en')?.name;
    return speciesName != null ? strings.capitalize(speciesName) : species?.name.capitalize() ?? pokeName.capitalize();
  }

  static String? formName(Pokemon pokemon, PokemonSpecies? species) {
    final speciesName = species?.name;
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

  static String getMoveName(Move move) {
    if (move.names.isEmpty) {
      return move.name.capitalize();
    }

    return move.names.firstWhereOrNull((n) => n.language.name == 'en')?.name ?? move.name.capitalize();
  }

  static String getMoveDescription(Move move) {
    return move.flavorTextEntries.firstWhereOrNull((n) => n.language.name == 'en')?.flavorText ??
        (move.flavorTextEntries.isNotEmpty ? move.flavorTextEntries.first.flavorText : '');
  }
}


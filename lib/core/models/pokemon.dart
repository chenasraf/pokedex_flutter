import 'dart:convert';
import 'package:strings/strings.dart' as strings;

import '../utils/extensions/iterable_extensions.dart';
import 'pokemon_species.dart';

class Pokemon {
  const Pokemon({
    required this.abilities,
    required this.baseExperience,
    required this.forms,
    required this.gameIndices,
    required this.height,
    required this.heldItems,
    required this.id,
    required this.isDefault,
    required this.locationAreaEncounters,
    required this.moves,
    required this.name,
    required this.order,
    required this.pastTypes,
    required this.species,
    required this.sprites,
    required this.stats,
    required this.types,
    required this.weight,
    required this.speciesData,
  });

  final List<Ability> abilities;
  final int? baseExperience;
  final List<ObjectRef> forms;
  final List<GameIndex> gameIndices;
  final int height;
  final List<HeldItem> heldItems;
  final int id;
  final bool isDefault;
  final String locationAreaEncounters;
  final List<Move> moves;
  final String name;
  final int order;
  final List<dynamic> pastTypes;
  final ObjectRef species;
  final Sprites sprites;
  final List<Stat> stats;
  final List<Type> types;
  final int weight;
  final PokemonSpecies? speciesData;

  String? get imageUrl =>
      sprites.other?.home.frontDefault ??
      sprites.frontDefault ??
      sprites.versions?.generationViii.icons.frontDefault;

  String get displayName {
    final speciesName = speciesData?.names
        .firstWhereOrNull((n) => n.language.name == 'en')
        ?.name;
    return speciesName != null
        ? strings.capitalize(speciesName)
        : name.splitMapJoin(
            RegExp(r'[ -]'),
            onMatch: (m) =>
                strings.capitalize(m.input.substring(m.start, m.end)),
            onNonMatch: (n) => strings.capitalize(n),
          );
  }

  String? get formName {
    final speciesName = species.name;
    if (speciesName == name) {
      return null;
    }
    final form = name.split('-').last;
    final presets = {
      'gmax': 'Gygantamax',
      'alola': 'Alolan',
      'galar': 'Galarian',
      'hisui': 'Hisuian',
    };
    return presets[form] ?? strings.capitalize(form);
  }

  Pokemon copyWith({
    List<Ability>? abilities,
    int? baseExperience,
    List<ObjectRef>? forms,
    List<GameIndex>? gameIndices,
    int? height,
    List<HeldItem>? heldItems,
    int? id,
    bool? isDefault,
    String? locationAreaEncounters,
    List<Move>? moves,
    String? name,
    int? order,
    List<dynamic>? pastTypes,
    ObjectRef? species,
    Sprites? sprites,
    List<Stat>? stats,
    List<Type>? types,
    int? weight,
    PokemonSpecies? speciesData,
  }) =>
      Pokemon(
        abilities: abilities ?? this.abilities,
        baseExperience: baseExperience ?? this.baseExperience,
        forms: forms ?? this.forms,
        gameIndices: gameIndices ?? this.gameIndices,
        height: height ?? this.height,
        heldItems: heldItems ?? this.heldItems,
        id: id ?? this.id,
        isDefault: isDefault ?? this.isDefault,
        locationAreaEncounters:
            locationAreaEncounters ?? this.locationAreaEncounters,
        moves: moves ?? this.moves,
        name: name ?? this.name,
        order: order ?? this.order,
        pastTypes: pastTypes ?? this.pastTypes,
        species: species ?? this.species,
        sprites: sprites ?? this.sprites,
        stats: stats ?? this.stats,
        types: types ?? this.types,
        weight: weight ?? this.weight,
        speciesData: speciesData ?? this.speciesData,
      );

  factory Pokemon.fromRawJson(String str) => Pokemon.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        abilities: List<Ability>.from(
            json["abilities"].map((x) => Ability.fromJson(x))),
        baseExperience: json["base_experience"],
        forms: List<ObjectRef>.from(
            json["forms"].map((x) => ObjectRef.fromJson(x))),
        gameIndices: List<GameIndex>.from(
            json["game_indices"].map((x) => GameIndex.fromJson(x))),
        height: json["height"],
        heldItems: List<HeldItem>.from(
            json["held_items"].map((x) => HeldItem.fromJson(x))),
        id: json["id"],
        isDefault: json["is_default"],
        locationAreaEncounters: json["location_area_encounters"],
        moves: List<Move>.from(json["moves"].map((x) => Move.fromJson(x))),
        name: json["name"],
        order: json["order"],
        pastTypes: List<dynamic>.from(json["past_types"].map((x) => x)),
        species: ObjectRef.fromJson(json["species"]),
        sprites: Sprites.fromJson(json["sprites"]),
        stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
        types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
        weight: json["weight"],
        speciesData: json['species_data'] != null
            ? PokemonSpecies.fromJson(json['species_data'])
            : null,
        // speciesData: PokemonSpecies.fromJson(json['species_data']),
      );

  Map<String, dynamic> toJson() => {
        "abilities": List<dynamic>.from(abilities.map((x) => x.toJson())),
        "base_experience": baseExperience,
        "forms": List<dynamic>.from(forms.map((x) => x.toJson())),
        "game_indices": List<dynamic>.from(gameIndices.map((x) => x.toJson())),
        "height": height,
        "held_items": List<dynamic>.from(heldItems.map((x) => x.toJson())),
        "id": id,
        "is_default": isDefault,
        "location_area_encounters": locationAreaEncounters,
        "moves": List<dynamic>.from(moves.map((x) => x.toJson())),
        "name": name,
        "order": order,
        "past_types": List<dynamic>.from(pastTypes.map((x) => x)),
        "species": species.toJson(),
        "sprites": sprites.toJson(),
        "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
        "types": List<dynamic>.from(types.map((x) => x.toJson())),
        "weight": weight,
        "species_data": speciesData?.toJson(),
      };
}

class Ability {
  Ability({
    required this.ability,
    required this.isHidden,
    required this.slot,
  });

  final ObjectRef ability;
  final bool isHidden;
  final int slot;

  Ability copyWith({
    ObjectRef? ability,
    bool? isHidden,
    int? slot,
  }) =>
      Ability(
        ability: ability ?? this.ability,
        isHidden: isHidden ?? this.isHidden,
        slot: slot ?? this.slot,
      );

  factory Ability.fromRawJson(String str) => Ability.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        ability: ObjectRef.fromJson(json["ability"]),
        isHidden: json["is_hidden"],
        slot: json["slot"],
      );

  Map<String, dynamic> toJson() => {
        "ability": ability.toJson(),
        "is_hidden": isHidden,
        "slot": slot,
      };
}

class ObjectRef {
  ObjectRef({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  ObjectRef copyWith({
    String? name,
    String? url,
  }) =>
      ObjectRef(
        name: name ?? this.name,
        url: url ?? this.url,
      );

  factory ObjectRef.fromRawJson(String str) =>
      ObjectRef.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ObjectRef.fromJson(Map<String, dynamic> json) => ObjectRef(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class GameIndex {
  GameIndex({
    required this.gameIndex,
    required this.version,
  });

  final int gameIndex;
  final ObjectRef version;

  GameIndex copyWith({
    int? gameIndex,
    ObjectRef? version,
  }) =>
      GameIndex(
        gameIndex: gameIndex ?? this.gameIndex,
        version: version ?? this.version,
      );

  factory GameIndex.fromRawJson(String str) =>
      GameIndex.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GameIndex.fromJson(Map<String, dynamic> json) => GameIndex(
        gameIndex: json["game_index"],
        version: ObjectRef.fromJson(json["version"]),
      );

  Map<String, dynamic> toJson() => {
        "game_index": gameIndex,
        "version": version.toJson(),
      };
}

class HeldItem {
  HeldItem({
    required this.item,
    required this.versionDetails,
  });

  final ObjectRef item;
  final List<VersionDetail> versionDetails;

  HeldItem copyWith({
    ObjectRef? item,
    List<VersionDetail>? versionDetails,
  }) =>
      HeldItem(
        item: item ?? this.item,
        versionDetails: versionDetails ?? this.versionDetails,
      );

  factory HeldItem.fromRawJson(String str) =>
      HeldItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HeldItem.fromJson(Map<String, dynamic> json) => HeldItem(
        item: ObjectRef.fromJson(json["item"]),
        versionDetails: List<VersionDetail>.from(
            json["version_details"].map((x) => VersionDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
        "version_details":
            List<dynamic>.from(versionDetails.map((x) => x.toJson())),
      };
}

class VersionDetail {
  VersionDetail({
    required this.rarity,
    required this.version,
  });

  final int rarity;
  final ObjectRef version;

  VersionDetail copyWith({
    int? rarity,
    ObjectRef? version,
  }) =>
      VersionDetail(
        rarity: rarity ?? this.rarity,
        version: version ?? this.version,
      );

  factory VersionDetail.fromRawJson(String str) =>
      VersionDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VersionDetail.fromJson(Map<String, dynamic> json) => VersionDetail(
        rarity: json["rarity"],
        version: ObjectRef.fromJson(json["version"]),
      );

  Map<String, dynamic> toJson() => {
        "rarity": rarity,
        "version": version.toJson(),
      };
}

class Move {
  Move({
    required this.move,
    required this.versionGroupDetails,
  });

  final ObjectRef move;
  final List<VersionGroupDetail> versionGroupDetails;

  Move copyWith({
    ObjectRef? move,
    List<VersionGroupDetail>? versionGroupDetails,
  }) =>
      Move(
        move: move ?? this.move,
        versionGroupDetails: versionGroupDetails ?? this.versionGroupDetails,
      );

  factory Move.fromRawJson(String str) => Move.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Move.fromJson(Map<String, dynamic> json) => Move(
        move: ObjectRef.fromJson(json["move"]),
        versionGroupDetails: List<VersionGroupDetail>.from(
            json["version_group_details"]
                .map((x) => VersionGroupDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "move": move.toJson(),
        "version_group_details":
            List<dynamic>.from(versionGroupDetails.map((x) => x.toJson())),
      };
}

class VersionGroupDetail {
  VersionGroupDetail({
    required this.levelLearnedAt,
    required this.moveLearnMethod,
    required this.versionGroup,
  });

  final int levelLearnedAt;
  final ObjectRef moveLearnMethod;
  final ObjectRef versionGroup;

  VersionGroupDetail copyWith({
    int? levelLearnedAt,
    ObjectRef? moveLearnMethod,
    ObjectRef? versionGroup,
  }) =>
      VersionGroupDetail(
        levelLearnedAt: levelLearnedAt ?? this.levelLearnedAt,
        moveLearnMethod: moveLearnMethod ?? this.moveLearnMethod,
        versionGroup: versionGroup ?? this.versionGroup,
      );

  factory VersionGroupDetail.fromRawJson(String str) =>
      VersionGroupDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VersionGroupDetail.fromJson(Map<String, dynamic> json) =>
      VersionGroupDetail(
        levelLearnedAt: json["level_learned_at"],
        moveLearnMethod: ObjectRef.fromJson(json["move_learn_method"]),
        versionGroup: ObjectRef.fromJson(json["version_group"]),
      );

  Map<String, dynamic> toJson() => {
        "level_learned_at": levelLearnedAt,
        "move_learn_method": moveLearnMethod.toJson(),
        "version_group": versionGroup.toJson(),
      };
}

class GenerationV {
  GenerationV({
    required this.blackWhite,
  });

  final Sprites blackWhite;

  GenerationV copyWith({
    Sprites? blackWhite,
  }) =>
      GenerationV(
        blackWhite: blackWhite ?? this.blackWhite,
      );

  factory GenerationV.fromRawJson(String str) =>
      GenerationV.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationV.fromJson(Map<String, dynamic> json) => GenerationV(
        blackWhite: Sprites.fromJson(json["black-white"]),
      );

  Map<String, dynamic> toJson() => {
        "black-white": blackWhite.toJson(),
      };
}

class GenerationVI {
  GenerationVI({
    required this.xY,
    required this.omegaRubyAlphaSapphire,
  });

  final Sprites xY;
  final Sprites omegaRubyAlphaSapphire;

  GenerationVI copyWith({
    Sprites? xY,
    Sprites? omegaRubyAlphaSapphire,
  }) =>
      GenerationVI(
        xY: xY ?? this.xY,
        omegaRubyAlphaSapphire:
            omegaRubyAlphaSapphire ?? this.omegaRubyAlphaSapphire,
      );

  factory GenerationVI.fromRawJson(String str) =>
      GenerationVI.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationVI.fromJson(Map<String, dynamic> json) => GenerationVI(
        xY: Sprites.fromJson(json["x-y"]),
        omegaRubyAlphaSapphire:
            Sprites.fromJson(json["omegaruby-alphasapphire"]),
      );

  Map<String, dynamic> toJson() => {
        "x-y": xY.toJson(),
        "omegaruby-alphasapphire": xY.toJson(),
      };
}

class GenerationIV {
  GenerationIV({
    required this.diamondPearl,
    required this.heartGoldSoulSilver,
    required this.platinum,
  });

  final Sprites diamondPearl;
  final Sprites heartGoldSoulSilver;
  final Sprites platinum;

  GenerationIV copyWith({
    Sprites? diamondPearl,
    Sprites? heartGoldSoulSilver,
    Sprites? platinum,
  }) =>
      GenerationIV(
        diamondPearl: diamondPearl ?? this.diamondPearl,
        heartGoldSoulSilver: heartGoldSoulSilver ?? this.heartGoldSoulSilver,
        platinum: platinum ?? this.platinum,
      );

  factory GenerationIV.fromRawJson(String str) =>
      GenerationIV.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationIV.fromJson(Map<String, dynamic> json) => GenerationIV(
        diamondPearl: Sprites.fromJson(json["diamond-pearl"]),
        heartGoldSoulSilver: Sprites.fromJson(json["heartgold-soulsilver"]),
        platinum: Sprites.fromJson(json["platinum"]),
      );

  Map<String, dynamic> toJson() => {
        "diamond-pearl": diamondPearl.toJson(),
        "heartgold-soulsilver": heartGoldSoulSilver.toJson(),
        "platinum": platinum.toJson(),
      };
}

class VersionSprites {
  VersionSprites({
    required this.generationI,
    required this.generationIi,
    required this.generationIii,
    required this.generationIv,
    required this.generationV,
    required this.generationVi,
    required this.generationVii,
    required this.generationViii,
  });

  final GenerationI generationI;
  final GenerationII generationIi;
  final GenerationIII generationIii;
  final GenerationIV generationIv;
  final GenerationV generationV;
  final GenerationVI generationVi;
  final GenerationVII generationVii;
  final GenerationVIII generationViii;

  VersionSprites copyWith({
    GenerationI? generationI,
    GenerationII? generationIi,
    GenerationIII? generationIii,
    GenerationIV? generationIv,
    GenerationV? generationV,
    GenerationVI? generationVi,
    GenerationVII? generationVii,
    GenerationVIII? generationViii,
  }) =>
      VersionSprites(
        generationI: generationI ?? this.generationI,
        generationIi: generationIi ?? this.generationIi,
        generationIii: generationIii ?? this.generationIii,
        generationIv: generationIv ?? this.generationIv,
        generationV: generationV ?? this.generationV,
        generationVi: generationVi ?? this.generationVi,
        generationVii: generationVii ?? this.generationVii,
        generationViii: generationViii ?? this.generationViii,
      );

  factory VersionSprites.fromRawJson(String str) =>
      VersionSprites.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VersionSprites.fromJson(Map<String, dynamic> json) => VersionSprites(
        generationI: GenerationI.fromJson(json["generation-i"]),
        generationIi: GenerationII.fromJson(json["generation-ii"]),
        generationIii: GenerationIII.fromJson(json["generation-iii"]),
        generationIv: GenerationIV.fromJson(json["generation-iv"]),
        generationV: GenerationV.fromJson(json["generation-v"]),
        generationVi: GenerationVI.fromJson(json["generation-vi"]),
        generationVii: GenerationVII.fromJson(json["generation-vii"]),
        generationViii: GenerationVIII.fromJson(json["generation-viii"]),
      );

  Map<String, dynamic> toJson() => {
        "generation-i": generationI.toJson(),
        "generation-ii": generationIi.toJson(),
        "generation-iii": generationIii.toJson(),
        "generation-iv": generationIv.toJson(),
        "generation-v": generationV.toJson(),
        "generation-vi": generationVi.toJson(),
        "generation-vii": generationVii.toJson(),
        "generation-viii": generationViii.toJson(),
      };
}

class Sprites {
  Sprites({
    required this.backDefault,
    required this.backFemale,
    required this.backShiny,
    required this.backShinyFemale,
    required this.frontDefault,
    required this.frontFemale,
    required this.frontShiny,
    required this.frontShinyFemale,
    required this.other,
    required this.versions,
    required this.animated,
  });

  final String? backDefault;
  final String? backFemale;
  final String? backShiny;
  final String? backShinyFemale;
  final String? frontDefault;
  final String? frontFemale;
  final String? frontShiny;
  final String? frontShinyFemale;
  final OtherSprites? other;
  final VersionSprites? versions;
  final Sprites? animated;

  Sprites copyWith({
    String? backDefault,
    String? backFemale,
    String? backShiny,
    String? backShinyFemale,
    String? frontDefault,
    String? frontFemale,
    String? frontShiny,
    String? frontShinyFemale,
    OtherSprites? other,
    VersionSprites? versions,
    Sprites? animated,
  }) =>
      Sprites(
        backDefault: backDefault ?? this.backDefault,
        backFemale: backFemale ?? this.backFemale,
        backShiny: backShiny ?? this.backShiny,
        backShinyFemale: backShinyFemale ?? this.backShinyFemale,
        frontDefault: frontDefault ?? this.frontDefault,
        frontFemale: frontFemale ?? this.frontFemale,
        frontShiny: frontShiny ?? this.frontShiny,
        frontShinyFemale: frontShinyFemale ?? this.frontShinyFemale,
        other: other ?? this.other,
        versions: versions ?? this.versions,
        animated: animated ?? this.animated,
      );

  factory Sprites.fromRawJson(String str) => Sprites.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
        backDefault: json["back_default"],
        backFemale: json["back_female"],
        backShiny: json["back_shiny"],
        backShinyFemale: json["back_shiny_female"],
        frontDefault: json["front_default"],
        frontFemale: json["front_female"],
        frontShiny: json["front_shiny"],
        frontShinyFemale: json["front_shiny_female"],
        other:
            json["other"] == null ? null : OtherSprites.fromJson(json["other"]),
        versions: json["versions"] == null
            ? null
            : VersionSprites.fromJson(json["versions"]),
        animated: json["animated"] == null
            ? null
            : Sprites.fromJson(json["animated"]),
      );

  Map<String, dynamic> toJson() => {
        "back_default": backDefault,
        "back_female": backFemale,
        "back_shiny": backShiny,
        "back_shiny_female": backShinyFemale,
        "front_default": frontDefault,
        "front_female": frontFemale,
        "front_shiny": frontShiny,
        "front_shiny_female": frontShinyFemale,
        "other": other?.toJson(),
        "versions": versions?.toJson(),
        "animated": animated?.toJson(),
      };
}

class GenerationI {
  GenerationI({
    required this.redBlue,
    required this.yellow,
  });

  final Sprites redBlue;
  final Sprites yellow;

  GenerationI copyWith({
    Sprites? redBlue,
    Sprites? yellow,
  }) =>
      GenerationI(
        redBlue: redBlue ?? this.redBlue,
        yellow: yellow ?? this.yellow,
      );

  factory GenerationI.fromRawJson(String str) =>
      GenerationI.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationI.fromJson(Map<String, dynamic> json) => GenerationI(
        redBlue: Sprites.fromJson(json["red-blue"]),
        yellow: Sprites.fromJson(json["yellow"]),
      );

  Map<String, dynamic> toJson() => {
        "red-blue": redBlue.toJson(),
        "yellow": yellow.toJson(),
      };
}

class GenerationII {
  GenerationII({
    required this.crystal,
    required this.gold,
    required this.silver,
  });

  final Sprites crystal;
  final Sprites gold;
  final Sprites silver;

  GenerationII copyWith({
    Sprites? crystal,
    Sprites? gold,
    Sprites? silver,
  }) =>
      GenerationII(
        crystal: crystal ?? this.crystal,
        gold: gold ?? this.gold,
        silver: silver ?? this.silver,
      );

  factory GenerationII.fromRawJson(String str) =>
      GenerationII.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationII.fromJson(Map<String, dynamic> json) => GenerationII(
        crystal: Sprites.fromJson(json["crystal"]),
        gold: Sprites.fromJson(json["gold"]),
        silver: Sprites.fromJson(json["silver"]),
      );

  Map<String, dynamic> toJson() => {
        "crystal": crystal.toJson(),
        "gold": gold.toJson(),
        "silver": silver.toJson(),
      };
}

class GenerationIII {
  GenerationIII({
    required this.emerald,
    required this.fireRedLeafGreen,
    required this.rubySapphire,
  });

  final Sprites emerald;
  final Sprites fireRedLeafGreen;
  final Sprites rubySapphire;

  GenerationIII copyWith({
    Sprites? emerald,
    Sprites? fireRedLeafGreen,
    Sprites? rubySapphire,
  }) =>
      GenerationIII(
        emerald: emerald ?? this.emerald,
        fireRedLeafGreen: fireRedLeafGreen ?? this.fireRedLeafGreen,
        rubySapphire: rubySapphire ?? this.rubySapphire,
      );

  factory GenerationIII.fromRawJson(String str) =>
      GenerationIII.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationIII.fromJson(Map<String, dynamic> json) => GenerationIII(
        emerald: Sprites.fromJson(json["emerald"]),
        fireRedLeafGreen: Sprites.fromJson(json["firered-leafgreen"]),
        rubySapphire: Sprites.fromJson(json["ruby-sapphire"]),
      );

  Map<String, dynamic> toJson() => {
        "emerald": emerald.toJson(),
        "firered-leafgreen": fireRedLeafGreen.toJson(),
        "ruby-sapphire": rubySapphire.toJson(),
      };
}

class GenerationVII {
  GenerationVII({
    required this.icons,
    required this.ultraSunUltraMoon,
  });

  final Sprites icons;
  final Sprites ultraSunUltraMoon;

  GenerationVII copyWith({
    Sprites? icons,
    Sprites? ultraSunUltraMoon,
  }) =>
      GenerationVII(
        icons: icons ?? this.icons,
        ultraSunUltraMoon: ultraSunUltraMoon ?? this.ultraSunUltraMoon,
      );

  factory GenerationVII.fromRawJson(String str) =>
      GenerationVII.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationVII.fromJson(Map<String, dynamic> json) => GenerationVII(
        icons: Sprites.fromJson(json["icons"]),
        ultraSunUltraMoon: Sprites.fromJson(json["ultra-sun-ultra-moon"]),
      );

  Map<String, dynamic> toJson() => {
        "icons": icons.toJson(),
        "ultra-sun-ultra-moon": ultraSunUltraMoon.toJson(),
      };
}

class GenerationVIII {
  GenerationVIII({
    required this.icons,
  });

  final Sprites icons;

  GenerationVIII copyWith({
    Sprites? icons,
  }) =>
      GenerationVIII(
        icons: icons ?? this.icons,
      );

  factory GenerationVIII.fromRawJson(String str) =>
      GenerationVIII.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenerationVIII.fromJson(Map<String, dynamic> json) => GenerationVIII(
        icons: Sprites.fromJson(json["icons"]),
      );

  Map<String, dynamic> toJson() => {
        "icons": icons.toJson(),
      };
}

class OtherSprites {
  OtherSprites({
    required this.dreamWorld,
    required this.home,
    required this.officialArtwork,
  });

  final Sprites dreamWorld;
  final Sprites home;
  final Sprites officialArtwork;

  OtherSprites copyWith({
    Sprites? dreamWorld,
    Sprites? home,
    Sprites? officialArtwork,
  }) =>
      OtherSprites(
        dreamWorld: dreamWorld ?? this.dreamWorld,
        home: home ?? this.home,
        officialArtwork: officialArtwork ?? this.officialArtwork,
      );

  factory OtherSprites.fromRawJson(String str) =>
      OtherSprites.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtherSprites.fromJson(Map<String, dynamic> json) => OtherSprites(
        dreamWorld: Sprites.fromJson(json["dream_world"]),
        home: Sprites.fromJson(json["home"]),
        officialArtwork: Sprites.fromJson(json["official-artwork"]),
      );

  Map<String, dynamic> toJson() => {
        "dream_world": dreamWorld.toJson(),
        "home": home.toJson(),
        "official-artwork": officialArtwork.toJson(),
      };
}

class Stat {
  Stat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  final int baseStat;
  final int effort;
  final ObjectRef stat;

  Stat copyWith({
    int? baseStat,
    int? effort,
    ObjectRef? stat,
  }) =>
      Stat(
        baseStat: baseStat ?? this.baseStat,
        effort: effort ?? this.effort,
        stat: stat ?? this.stat,
      );

  factory Stat.fromRawJson(String str) => Stat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        baseStat: json["base_stat"],
        effort: json["effort"],
        stat: ObjectRef.fromJson(json["stat"]),
      );

  Map<String, dynamic> toJson() => {
        "base_stat": baseStat,
        "effort": effort,
        "stat": stat.toJson(),
      };
}

class Type {
  Type({
    required this.slot,
    required this.type,
  });

  final int slot;
  final ObjectRef type;

  Type copyWith({
    int? slot,
    ObjectRef? type,
  }) =>
      Type(
        slot: slot ?? this.slot,
        type: type ?? this.type,
      );

  factory Type.fromRawJson(String str) => Type.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        slot: json["slot"],
        type: ObjectRef.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "slot": slot,
        "type": type.toJson(),
      };
}

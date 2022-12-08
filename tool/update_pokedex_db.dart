// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:file/local.dart';
import 'package:http/http.dart' as http;
import 'package:file/file.dart';
import 'package:path/path.dart' as path;
import 'package:pokedex/core/models/pokemon.dart';
import 'package:pokedex/core/models/pokemon_species.dart';
import 'package:queue/queue.dart';

const fs = LocalFileSystem();
const apiBase = 'https://pokeapi.co/api/v2';
final cacheRoot = fs.directory(path.join('tool', 'data'));
final finalDataDir = fs.directory(path.join('lib', 'data'));

final queue = Queue(parallel: 10);
// const maxRetries = 5;

Future<String> downloadFile({
  required String uriPath,
  required String fileName,
  required String saveDir,
  // int currentTry = 1,
}) async {
  final url = '$apiBase/$uriPath';
  final cacheDir = fs.directory(path.join(cacheRoot.path, saveDir));
  await cacheDir.create(recursive: true);
  final file = fs.file(path.join(cacheDir.path, '$fileName.json'));

  if (file.existsSync()) {
    print('Skipping $saveDir/$fileName... (already exists)');
    final body = file.readAsStringSync();
    return body;
  }

  print('Downloading $saveDir/$fileName...');
  final response = await http.get(Uri.parse(url));
  final body = sanitizeString(response.body);
  if (body == 'Not Found') {
    return '';
  }
  // if (body == 'Not Found') {
  //   if (currentTry < maxRetries) {
  //     print('Retrying $saveDir/$fileName... ($currentTry/$maxRetries)');
  //     return downloadFile(
  //       uriPath: uriPath,
  //       fileName: fileName,
  //       saveDir: saveDir,
  //       currentTry: currentTry + 1,
  //     );
  //   } else {
  //     print('Failed to download $saveDir/$fileName... (max retries reached)');
  //     return body;
  //   }
  // }
  await writeFile(file, body);
  return body;
}

Future<Pokemon> downloadPokemon(String name) async {
  final speciesName =
      name.endsWith('-f') || name.endsWith('-m') ? name : name.split('-').first;
  final res = await Future.wait([
    downloadFile(
      uriPath: 'pokemon/$name',
      fileName: name,
      saveDir: 'pokemon',
    ),
    downloadFile(
      uriPath: 'pokemon-species/$speciesName',
      fileName: speciesName,
      saveDir: 'pokemon-species',
    )
  ]);
  try {
    final pokeData = jsonDecode(res[0]);
    final speciesData = res[1].isNotEmpty ? jsonDecode(res[1]) : null;
    return Pokemon.fromJson({...pokeData, 'species_data': speciesData});
  } catch (e) {
    print('Error decoding $name');
    rethrow;
  }
}

Future<void> downloadList({
  required String uriPath,
  required String fileName,
  required void Function(Map<String, dynamic> json) onDownload,
}) async {
  final queue = Queue(parallel: 10);

  const fs = LocalFileSystem();
  final url = '$apiBase/$uriPath?limit=10000';
  final cacheDir = fs.directory(path.join(cacheRoot.path, 'lists'));
  await cacheDir.create(recursive: true);
  final file = fs.file(path.join(cacheDir.path, '$fileName.json'));

  final response = await http.get(Uri.parse(url));
  final body = sanitizeString(response.body);
  await writeFile(file, body);

  final json = jsonDecode(body) as Map<String, dynamic>;
  var results = json['results'] as List<dynamic>;
  for (final item in results) {
    queue.add(() async => onDownload(item));
  }
}

Future<void> downloadAllPokemon() async {
  final pokemon = <Pokemon>[];
  await downloadList(
    uriPath: 'pokemon',
    fileName: 'pokemon',
    onDownload: (item) {
      final name = item['name'] as String;
      queue.add(() => downloadPokemon(name).then((poke) => pokemon.add(poke)));
    },
  );
  await queue.onComplete;
  await finalDataDir.create(recursive: true);
  final file = fs.file(path.join(finalDataDir.path, 'pokemon.dart'));
  print('Collecting Pokemon...');
  String out = [
    "import '../core/models/pokemon.dart';",
    '',
    'Map<String, Pokemon> getAllPokemon() => <String, Pokemon>{',
  ].join('\n');
  var i = 1;
  final _queue = Queue(parallel: 50);
  for (final poke in pokemon..sort((a, b) => a.id.compareTo(b.id))) {
    _queue.add(
      () => Future.microtask(() {
        stdout.write('  Adding $i of ${pokemon.length}\r');
        out +=
            "'${poke.name}': Pokemon.fromRawJson('''${jsonEncode(poke.toJson())}''',),\n";
        i++;
      }),
    );
  }
  await _queue.onComplete;
  out += '};';
  await writeAndFormatFile(file, out);
}

Future<void> writeAndFormatFile(File file, String out) async {
  await writeFile(file, out);
  print('Formatting ${file.path}...');
  final proc = await Process.start('dart', ['format', '--fix', file.path]);
  proc.stdout.pipe(stdout);
  proc.stderr.pipe(stderr);
  await proc.exitCode;
}

Future<void> writeFile(File file, String out) async {
  // if (await file.exists()) {
  //   await file.delete();
  // }
  print('Writing ${file.path}...');
  await file.writeAsString(sanitizeString(out));
}

String sanitizeString(String out) => out
    .replaceAll('\f', '\\n')
    .replaceAll('\\f', '\\n')
    .replaceAll('\\n', '\\\\n');

Future<String> downloadMove(String name) async {
  return downloadFile(
    uriPath: 'move/$name',
    fileName: name,
    saveDir: 'moves',
  );
}

Future<void> downloadAllMoves() async {
  return downloadList(
    uriPath: 'move',
    fileName: 'moves',
    onDownload: ((json) => downloadMove(json['name'] as String)),
  );
}

Future<void> main() async {
  final queue = Queue(parallel: 10);

  queue.add(() => downloadAllPokemon());
  queue.add(() => downloadAllMoves());

  await queue.onComplete;
}

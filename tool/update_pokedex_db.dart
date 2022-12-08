// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:file/local.dart';
import 'package:http/http.dart' as http;
import 'package:file/file.dart';
import 'package:path/path.dart' as path;
import 'package:pokedex/core/models/pokemon.dart';
import 'package:queue/queue.dart';

const fs = LocalFileSystem();
const apiBase = 'https://pokeapi.co/api/v2';
final cacheRoot = fs.directory(path.join('tool', 'data'));
final finalDataDir = fs.directory(path.join('lib', 'data'));

Future<String> downloadFile({
  required String uriPath,
  required String fileName,
  required String saveDir,
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
  await file.writeAsString(response.body);
  return response.body;
}

Future<Pokemon> downloadPokemon(String name) {
  return downloadFile(
    uriPath: 'pokemon/$name',
    fileName: name,
    saveDir: 'pokemon',
  ).then((x) => Pokemon.fromRawJson(x));
}

Future<void> downloadPokemonSpecies(String name) {
  return downloadFile(
    uriPath: 'pokemon-species/$name',
    fileName: name,
    saveDir: 'pokemon-species',
  );
}

Future<void> downloadList({
  required String uriPath,
  required String fileName,
  required void Function(Map<String, dynamic> json) onDownload,
}) async {
  const fs = LocalFileSystem();
  final url = '$apiBase/$uriPath?limit=10000';
  final cacheDir = fs.directory(path.join(cacheRoot.path, 'lists'));
  await cacheDir.create(recursive: true);
  final file = fs.file(path.join(cacheDir.path, '$fileName.json'));

  final response = await http.get(Uri.parse(url));
  await file.writeAsString(response.body);

  final json = jsonDecode(response.body) as Map<String, dynamic>;
  for (final item in json['results'] as List<dynamic>) {
    onDownload(item);
  }
}

Future<void> downloadAllPokemon() async {
  final queue = Queue(parallel: 10);
  final pokemon = <Pokemon>[];
  await downloadList(
    uriPath: 'pokemon',
    fileName: 'pokemon',
    onDownload: (item) {
      final name = item['name'] as String;
      queue.add(() => downloadPokemon(name).then((poke) => pokemon.add(poke)));
      queue.add(() => downloadPokemonSpecies(name));
    },
  );
  await queue.onComplete;
  await finalDataDir.create(recursive: true);
  final file = fs.file(path.join(finalDataDir.path, 'pokemon.dart'));
  file.delete();
  print('Collecting Pokemon...');
  String out = [
    "import '../core/models/pokemon.dart';",
    '',
    'Map<String, Pokemon> getAllPokemon() => <String, Pokemon>{',
  ].join('\n');
  for (final poke in pokemon..sort((a, b) => a.id.compareTo(b.id))) {
    out +=
        "'${poke.name}': Pokemon.fromRawJson('${jsonEncode(poke.toJson())}'),\n";
  }
  out += '};';
  print('Writing ${file.path}...');
  await file.writeAsString(out);
  print('Formatting ${file.path}...');
  final proc = await Process.start('dart', ['format', '--fix', file.path]);
  proc.stdout.pipe(stdout);
  proc.stderr.pipe(stderr);
  await proc.exitCode;
}

Future<String> downloadMove(String name) async {
  return downloadFile(
    uriPath: 'move/$name',
    fileName: name,
    saveDir: 'moves',
  );
}

Future<void> downloadAllMoves() async {
  final queue = Queue(parallel: 10);
  await downloadList(
    uriPath: 'move',
    fileName: 'moves',
    onDownload: ((json) => downloadMove(json['name'] as String)),
  );
  return queue.onComplete;
}

Future<void> main() async {
  final queue = Queue(parallel: 10);

  queue.add(() => downloadAllPokemon());
  queue.add(() => downloadAllMoves());

  await queue.onComplete;
}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:localstore/localstore.dart';
import 'package:pokemon_api/pokemon_api.dart';

class LocalstoreCache extends CacheManager {
  static const String collection = 'cache';

  String _filename(String key) => '${md5.convert(utf8.encode(key))}.json';

  @override
  Future<void> add(String key, value) {
    return Localstore.instance.collection(collection).doc(_filename(key)).set(value);
  }

  @override
  Future<void> clear() {
    return Localstore.instance.collection(collection).delete();
  }

  @override
  Future<bool> contains(String key) async {
    return (await Localstore.instance.collection(collection).doc(_filename(key)).get()) != null;
  }

  @override
  Future<void> fill(Map<String, dynamic> cache) {
    return Future.wait(cache.entries.map((doc) => add(doc.key, doc.value)));
  }

  @override
  Future get(String key) {
    return Localstore.instance.collection(collection).doc(_filename(key)).get();
  }

  @override
  Future<void> remove(String key) {
    return Localstore.instance.collection(collection).doc(_filename(key)).delete();
  }
}


import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:pokemon_api/pokemon_api.dart';
import 'package:provider/provider.dart';

import 'core/routes.dart';
import 'modules/PokemonDetails/pokemon_details_page.dart';
import 'modules/PokemonList/pokemon_list_controller.dart';
import 'modules/PokemonList/pokemon_list_page.dart';

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

void main() {
  PokemonAPIClient.instance.setCache(LocalstoreCache());
  runApp(const MyApp());
}

final themeData = ThemeData(
  primarySwatch: Colors.red,
  useMaterial3: true,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonListController(),
      child: MaterialApp(
        title: 'Pokedex',
        theme: themeData,
        routes: {
          Routes.home: (context) => const PokemonListPage(),
          Routes.pokemonDetails: (context) => const PokemonDetailsPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


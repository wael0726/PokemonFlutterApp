import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2/auth.dart';
import 'home.dart';
import 'maindrawer.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => AuthProvider()..loadToken(),
    child: const App(),
  ),
);

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TP2",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("TP2"),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: const MainDrawer(),
        body: const Home(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_app_productos/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Productos App',
        initialRoute: 'home',
        routes: {
          'login': (_) => const LoginScreen(),
          'home': (_) => const HomeScreen()
        },
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.grey[300],
            appBarTheme: const AppBarTheme(color: Colors.indigo, elevation: 0),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.indigo, elevation: 0)));
  }
}

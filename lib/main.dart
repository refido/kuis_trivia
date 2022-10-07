import 'package:flutter/material.dart';
import 'ui/pages/home.dart';
// import 'package:opentrivia/ui/pages/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Open Trivia',
      theme: ThemeData(
        fontFamily: "Montserrat",
        // buttonColor: Colors.pink,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(secondary: Colors.indigo)
      ),
      home: HomePage(),
    );
  }
}
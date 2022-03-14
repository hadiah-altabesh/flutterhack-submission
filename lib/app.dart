import 'package:flutter/material.dart';
import 'package:slide_puzzle/presentation/puzzle/view/puzzle_page.dart';
import 'package:slide_puzzle/presentation/start/view/start_page.dart';

class Puzzle extends StatelessWidget {
  const Puzzle({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Slide Puzzle',
      home: StartPage(),
    );
  }
}

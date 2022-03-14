import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/constants/testStyles.dart';
import 'package:slide_puzzle/presentation/imageChoice/view/image_choice_page.dart';
import 'package:slide_puzzle/presentation/puzzle/view/puzzle_page.dart';
import 'package:slide_puzzle/widgets/button.dart';
import 'package:flutter/services.dart' show rootBundle;

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClickyButton(
            child: const Text(
              'Start a fast Turn',
              style: TextStyles.largeWhite,
            ),
            onPressed: () async {
              int? choice;
              await showDialog<void>(
                  context: context,
                  // barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Dimension Choice'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('3x3 4x4 5x5?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('3x3'),
                          onPressed: () {
                            choice = 3;
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('4x4'),
                          onPressed: () {
                            choice = 4;
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('5x5'),
                          onPressed: () {
                            choice = 5;
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              if (choice != null) {
                Navigator.push(context, MaterialPageRoute(builder: (ctxt) {
                  return PuzzlePage(
                    dimension: choice!,
                  );
                }));
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          ClickyButton(
            child: const Text(
              'Start a fast Image Turn',
              style: TextStyles.largeWhite,
            ),
            onPressed: () async {
              int? choice;
              await showDialog<void>(
                  context: context,
                  // barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Dimension Choice'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text('3x3 4x4 5x5?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('3x3'),
                          onPressed: () {
                            choice = 3;
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('4x4'),
                          onPressed: () {
                            choice = 4;
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('5x5'),
                          onPressed: () {
                            choice = 5;
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              if (choice != null) {
                ByteData bytes =
                    await rootBundle.load("assets/images/test.jpg");
                Navigator.push(context, MaterialPageRoute(builder: (ctxt) {
                  return PuzzlePage(
                    puzzleImage: bytes.buffer.asUint8List(),
                    dimension: choice!,
                  );
                }));
              }
            },
          ),
          ElevatedButton(
            child: Text("test"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  // if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                  // return null; // Use the component's default.
                },
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctxt) {
                return ImageChoicePage();
              }));
            },
          )
        ],
      )),
    );
  }
}

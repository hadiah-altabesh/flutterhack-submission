import 'package:flutter/material.dart';
import 'package:slide_puzzle/presentation/puzzle/view/puzzle_page.dart';
import 'package:unsplash_client/unsplash_client.dart';

class ImageChoicePage extends StatefulWidget {
  const ImageChoicePage({Key? key}) : super(key: key);

  @override
  State<ImageChoicePage> createState() => _ImageChoicePageState();
}

class _ImageChoicePageState extends State<ImageChoicePage>
    with TickerProviderStateMixin {
  List<List<Photo>> images = [[], [], [], []];
  UnsplashClient client = UnsplashClient(
    settings: const ClientSettings(
        credentials: AppCredentials(
      accessKey: 'ay92sRmqGd8NS494GL2CLx2aPGfSL4peI_WfVekJPuE',
      secretKey: 'ajxJC1q81mWSSvZUkDyJCzCU43rBFsr7yHpZNG9fnrY',
    )),
  );
  TabController? _tabController;

  final data = {
    0: "greenery",
    1: "biology",
    2: "kittens",
    3: "robots",
  };

  @override
  void initState() {
    load("greenery", 0);

    // print("FB:X _HNPageState:initState()");
    _tabController = TabController(vsync: this, length: 4);
    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging ||
          _tabController!.index != _tabController!.previousIndex) {
        if (images[_tabController!.index].isEmpty) {
          load(data[_tabController!.index]!, _tabController!.index);
        }
      }
      // Tab Changed tapping on new tab
      //  onTabTap();
      // else if (_tabController!.index != _tabController!.previousIndex)
      // Tab Changed swiping to a new tab
      // {}
      // onTabDrag();
    });
    super.initState();
  }

  load(String q, int index, {bool more = false}) async {
    // print("test");
    // client.photos.
    if (images[index].isNotEmpty && !more) return;
    final photos = await client.photos
        .random(
          count: images[index].length + 10,
          query: q,
          orientation: PhotoOrientation.squarish,
        )
        .goAndGet();
    setState(() {
      images[index].addAll(photos.getRange(photos.length - 10, photos.length));
    });
    // print(photos);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: const Text('Choose Image'),
            pinned: true,
            floating: true,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(child: Text('Greenery')),
                Tab(child: Text('Biology')),
                Tab(child: Text('Kittens')),
                Tab(child: Text('Robots')),
                // Tab(child: Text('Car')),
                // Tab(child: Text('Cycle')),
                // Tab(child: Text('Boat')),
              ],
              // onTap: (int i) async {
              //   if (i == 1) {
              //     load('biology', 1);
              //   }
              // },
            ),
          ),
        ];
      },
      body: TabBarView(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          children: List.generate(4, (index) {
            return images[index].isEmpty
                ? LinearProgressIndicator()
                : SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        ...List.generate(images[index].length, (ind) {
                          return IconButton(
                              iconSize: 200,
                              splashRadius: 1,
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
                                  // ByteData bytes = await rootBundle
                                  //     .load("assets/images/test.jpg");
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (ctxt) {
                                    return PuzzlePage(
                                      networkPuzzleImage: images[index][ind]
                                          .urls
                                          .raw
                                          .resizePhoto(height: 800, width: 800),
                                      // puzzleImage: bytes.buffer.asUint8List(),
                                      dimension: choice!,
                                    );
                                  }));
                                }
                              },
                              icon: Image.network(
                                images[index][ind]
                                    .urls
                                    .raw
                                    .resizePhoto(width: 200, height: 200)
                                    .toString(),
                                // height: 200,
                                // width: 200,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ));
                        }),
                        ElevatedButton(
                            onPressed: () {
                              load(data[index]!, index, more: true);
                            },
                            child: Text("Load More"))
                      ],
                    ),
                  );
          })
          // <Widget>[
          //   Icon(Icons.flight, size: 350),
          //   Icon(Icons.directions_transit, size: 350),
          //   Icon(Icons.directions_car, size: 350),
          //   Icon(Icons.directions_bike, size: 350),
          //   Icon(Icons.directions_boat, size: 350),
          // ],
          ),
    ));
  }
}

import 'dart:async';
import 'dart:math';

import 'package:nothing/common/prefix_header.dart';

class FlutterStream extends StatefulWidget {
  const FlutterStream({super.key});

  @override
  State<FlutterStream> createState() => _FlutterStreamState();
}

class _FlutterStreamState extends State<FlutterStream> {
  final _inputController = StreamController.broadcast();
  final _scoreController = StreamController.broadcast();

  @override
  void dispose() {
    _inputController.close();
    _scoreController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
              stream: _scoreController.stream.transform(TallyTransformer()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('score: ${snapshot.data}');
                }
                return const Text('score: 0');
              }),
          elevation: 0,
          leading: const SizedBox.shrink(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: InkWell(
                onTap: () async {
                  final NavigatorState navigatorState = Navigator.of(context);

                  bool? result = await showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Logout ?',
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text(
                                            'cancel',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text(
                                            'confirm',
                                            style: TextStyle(color: Colors.red[300]),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                  if (result == true) {
                    navigatorState.pop();
                  }
                },
                child: const Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.green,
                ),
              ),
            )
          ],
          // backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
            stream: _inputController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError && snapshot.error is StreamError) {
                StreamError error = snapshot.error as StreamError;
                return Text('$error');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: InkWell(onTap: () {}, child: const Text('Failure and Retry')),
                );
              }
              return Stack(
                children: List.generate(
                    8,
                    (index) => Puzzle(
                          inputController: _inputController,
                          scoreController: _scoreController,
                        )),
              );
            }),
        bottomNavigationBar: KeyPad(
          controller: _inputController,
        ),
      ),
    );
  }
}

class TallyTransformer implements StreamTransformer {
  int sum = 0;
  final StreamController _controller = StreamController();

  @override
  Stream bind(Stream stream) {
    stream.listen((event) {
      sum += event as int;
      _controller.add(sum);
    });
    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() => StreamTransformer.castFrom(this);
}

class Puzzle extends StatefulWidget {
  const Puzzle({super.key, required this.inputController, required this.scoreController});

  final StreamController inputController;
  final StreamController scoreController;

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> with SingleTickerProviderStateMixin {
  late int a, b, result;
  late Color color;
  late double left;
  late Duration duration;
  double maxHeight = 568;

  late final AnimationController _animationController = AnimationController(vsync: this);

  final GlobalKey _globalKey = GlobalKey();

  void reset([double from = 0]) {
    result = Random().nextInt(9) + 1;
    a = Random().nextInt(result) + 1;
    b = result - a;
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(.5);
    left = Random().nextDouble() * (AppSize.screenWidth - 80);
    duration = Duration(milliseconds: 5000 + Random().nextInt(5000));
    _animationController.duration = duration;
    _animationController.reset();
    _animationController.forward(from: from);
  }

  @override
  void initState() {
    super.initState();
    reset();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        widget.scoreController.add(-10);
        reset();
      }
    });

    widget.inputController.stream.listen((event) {
      if (event == result) {
        widget.scoreController.add(10);
        reset();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = _globalKey.currentContext!.findRenderObject() as RenderBox;
      maxHeight = renderBox.size.height + 100;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _globalKey,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Positioned(
                left: left,
                top: _animationController.value * maxHeight - 100,
                child: InkWell(
                  onTap: () {
                    widget.inputController.close();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text('$a+$b'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StreamError {
  StreamError(this.key, this.value);

  final String key;
  final String value;

  @override
  String toString() {
    return {
      'key': key,
      'value': value,
    }.toJsonString()!;
  }
}

class KeyPad extends StatelessWidget {
  const KeyPad({super.key, required this.controller});

  final StreamController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 2 / 1,
      children: List.generate(
        9,
        (index) {
          index = index + 1;
          return InkWell(
            onTap: () {
              controller.add(index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.primaries[index][200],
                shape: BoxShape.rectangle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

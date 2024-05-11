import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nothing/page/flutter/shiny_text.dart';

class FlutterCube extends StatefulWidget {
  const FlutterCube({super.key});

  @override
  State<FlutterCube> createState() => _FlutterCubeState();
}

class _FlutterCubeState extends State<FlutterCube> {
  double _rx = 0;
  double _ry = 0;
  double _rz = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cube'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanUpdate: (details) {
                  print(details.delta);
                  // _rx = _rx + details.delta.dy * 0.01;
                  _ry += details.delta.dx * 0.01;
                  // _ry =  _ry < 0 ? -(_ry % pi) : _ry % pi;

                  // print('_ry = $_ry');
                  setState(() {
                    // _rx %= pi * 2;
                    _ry %= pi;
                  });
                },
                child: Cube(
                  rotateX: _rx,
                  rotateY: _ry,
                  rotateZ: _rz,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Column(
                  children: [
                    // Slider(
                    //     value: _rx,
                    //     min: -pi,
                    //     max: pi,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _rx = value;
                    //       });
                    //     }),
                    // Slider(
                    //     value: _ry,
                    //     min: -pi,
                    //     max: pi,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _ry = value;
                    //       });
                    //     }),
                    // Slider(
                    //     value: _rz,
                    //     min: -pi,
                    //     max: pi,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _rz = value;
                    //       });
                    //     }),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _rx = 0;
              _ry = 0;
              _rz = 0;
            });
          },
          child: const Icon(
            Icons.refresh,
          ),
        ),
      ),
    );
  }
}

class Cube extends StatelessWidget {
  final double width, height, depth;
  final double rotateX, rotateY, rotateZ;

  const Cube({
    super.key,
    this.width = 200,
    this.height = 200,
    this.depth = 200,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.rotateZ = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget front = const SideWidget(
      SideType.front,
      label: 'front',
    );
    Widget back = const SideWidget(
      SideType.back,
      label: 'back',
    );
    Widget port = const SideWidget(
      SideType.port,
      label: 'port',
    );
    Widget starboard = const SideWidget(
      SideType.starboard,
      label: 'starboard',
    );
    Widget top = const SideWidget(
      SideType.top,
      label: 'top',
    );
    Widget bottom = const SideWidget(
      SideType.bottom,
      label: 'bottom',
    );

    List<Widget> children = [];

    // print('ry=${rotateY / oneAngle},_rx=${rotateX / oneAngle}');

    double _rx = rotateX / (pi / 4);
    double _ry = rotateY / (pi / 4);
    double _rz = rotateZ / (pi / 4);

    if ((_rx > 2 && _rx <= 4) || (_rx >= -4 && _rx < -2)) {
      front = const SideWidget(
        SideType.back,
        label: 'back',
      );
      back = const SideWidget(
        SideType.front,
        label: 'back',
      );
      port = const SideWidget(
        SideType.starboard,
        label: 'back',
      );
      starboard = const SideWidget(
        SideType.port,
        label: 'back',
      );
    }

    if ((_rz > 2 && _rz <= 4) || (_rz >= -4 && _rz < -2)) {
      port = const SideWidget(
        SideType.starboard,
        label: 'back',
      );
      starboard = const SideWidget(
        SideType.port,
        label: 'back',
      );
    }

    if (_ry > -1 && _ry <= 1) {
      if (_ry >= 0) {
        children = [front, port];
      } else {
        children = [starboard, front];
      }
    } else if (_ry > -2 && _ry <= 2) {
      if (_ry > 0) {
        children = [port, front];
      } else {
        children = [starboard, front];
      }
    } else if (_ry > -3 && _ry <= 3) {
      if (_ry > 0) {
        children = [port, back];
      } else {
        children = [starboard, back];
      }
    } else if (_ry >= -4 && _ry <= 4) {
      if (_ry > 0) {
        children = [port, back];
      } else {
        children = [starboard, back];
      }
    }

    if (rotateX > 0.0) {
      children.add(bottom);
    } else {
      children.add(top);
    }

    // children.exchange(top, back);

    return Transform(
      transform: Matrix4.identity()
        // ..setEntry(3, 2, 0.001)
        ..rotateX(rotateX)
        ..rotateY(rotateY)
        ..rotateZ(rotateZ),
      alignment: Alignment.center,
      child: Stack(children: children),
    );
  }
}

class SideModel {
  Key? key;
  final SideType type;
  final Widget side;

  List<SideWidget> get sides => [];

  SideModel({required this.side, required this.type});

  @override
  bool operator ==(Object other) {
    return type == (other as SideModel).type;
  }

  @override
  int get hashCode => type.hashCode;
}

enum SideType {
  front,
  back,
  top,
  bottom,
  port,
  starboard,
}

class SideWidget extends StatelessWidget {
  const SideWidget(
    this.sideType, {
    super.key,
    this.label,
    this.width = 200,
    this.height = 200,
    this.depth = 200,
  });

  final double width, height, depth;
  final SideType sideType;
  final String? label;

  @override
  Widget build(BuildContext context) {
    late final double translate;
    late final Matrix4 transform;
    late final Color color;
    switch (sideType) {
      case SideType.front:
        translate = depth / 2;
        transform = Matrix4.identity()..translate(0.0, 0.0, translate);
        color = Colors.red;
      case SideType.back:
        translate = depth / -2;
        transform = Matrix4.identity()
          ..translate(0.0, 0.0, translate)
          ..rotateY(pi);
        color = Colors.blue;
      case SideType.top:
        translate = height / -2;
        transform = Matrix4.identity()
          ..translate(0.0, translate, 0.0)
          ..rotateX(-pi / 2);
        color = Colors.cyan;
      case SideType.bottom:
        translate = height / 2;
        transform = Matrix4.identity()
          ..translate(0.0, translate, 0.0)
          ..rotateX(pi / 2);
        color = Colors.green;
      case SideType.port:
        translate = width / -2;
        transform = Matrix4.identity()
          ..translate(translate, 0.0, 0.0)
          ..rotateY(-pi / 2);
        color = Colors.orange;
      case SideType.starboard:
        translate = width / 2;
        transform = Matrix4.identity()
          ..translate(translate, 0.0, 0.0)
          ..rotateY(pi / 2);
        color = Colors.pink;
    }

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: Container(
        color: color,
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: Center(
          child: ShinyText(label: label ?? ''),
        ),
      ),
    );
  }
}

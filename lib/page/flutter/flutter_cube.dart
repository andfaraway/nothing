import 'dart:math';

import 'package:flutter/material.dart';

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
                  // _rx = details.delta.dx * 0.01;
                  // _ry = details.delta.dy * 0.01;
                  // setState(() {
                  //   _rx %= pi * 2;
                  //   _ry %= pi * 2;
                  // });
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
                    Slider(
                        value: _rx,
                        min: -pi,
                        max: pi,
                        onChanged: (value) {
                          setState(() {
                            _rx = value;
                          });
                        }),
                    Slider(
                        value: _ry,
                        min: -pi,
                        max: pi,
                        onChanged: (value) {
                          setState(() {
                            _ry = value;
                          });
                        }),
                    Slider(
                        value: _rz,
                        min: -pi,
                        max: pi,
                        onChanged: (value) {
                          setState(() {
                            _rz = value;
                          });
                        }),
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
    final front = _buildSide(SideType.front);
    final back = _buildSide(SideType.back);
    final port = _buildSide(SideType.port);
    final starboard = _buildSide(SideType.starboard);
    final top = _buildSide(SideType.top);
    final bottom = _buildSide(SideType.bottom);

    List<Widget> children = [];

    const oneAngle = pi / 4;
    print(rotateX);

    if (rotateY > -oneAngle && rotateY < oneAngle) {
      if (rotateY > 0) {
        children = [front, port];
      } else {
        children = [starboard, front];
      }
    } else if (rotateY > oneAngle * -2 && rotateY < oneAngle * 2) {
      if (rotateY > 0) {
        children = [back, port];
      } else {
        children = [back, starboard];
      }
    } else if (rotateY > oneAngle * -3 && rotateY < oneAngle * 3) {
      if (rotateY > 0) {
        children = [back, starboard];
      } else {
        children = [port, back];
      }
    } else if (rotateY >= oneAngle * -4 && rotateY <= oneAngle * 4) {
      if (rotateY > 0) {
        children = [front, starboard];
      } else {
        children = [front, port];
      }
    }

    if (rotateX > 0.0) {
      children.add(top);
    } else {
      children.add(bottom);
    }

    return Transform(
      transform: Matrix4.identity()
        // ..setEntry(3, 2, 0.001)
        ..rotateX(rotateX)
        ..rotateY(rotateY),
      alignment: Alignment.center,
      child: Stack(children: children),
    );
  }

  /// Build 4 thinner sides: 0=top; 1=starboard(right); 2=bottom; 3=port(left)
  Widget _buildSide(SideType sideType) {
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
          child: Text('$sideType'),
        ),
      ),
    );
  }
}

enum SideType {
  front,
  back,
  top,
  bottom,
  port,
  starboard,
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ybjf/common/utils/prefix_header.dart';

final OverlayEntry _entry = OverlayEntry(builder: (_) {
  return const GridWidget();
});

class GridWidget extends StatelessWidget {
  const GridWidget({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    print('show');
    Overlay.of(context).insert(_entry);
  }

  static void hide() {
    print('hide');
    _entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GridWidgetPainter(),
      ),
    );
  }
}

class _GridWidgetPainter extends CustomPainter {
  final double strokeWidth;
  final double opacity;

  _GridWidgetPainter({this.strokeWidth = 10, this.opacity = .2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeWidth = strokeWidth;
    bool hideColor = true;
    for (double i = 0; i < size.height; i += strokeWidth) {
      if (hideColor) {
        paint.color = randomColor(opacity: opacity);
      } else {
        paint.color = Colors.transparent;
      }
      hideColor = !hideColor;
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    hideColor = true;
    for (double i = 0; i < size.height; i += strokeWidth) {
      if (hideColor) {
        paint.color = randomColor(opacity: opacity);
      } else {
        paint.color = Colors.transparent;
      }
      hideColor = !hideColor;
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridWidgetPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.opacity != opacity;
  }

  static Color randomColor({double opacity = 1}) {
    int red = getRandom(max: 255);
    int green = getRandom(max: 255);
    int blue = getRandom(max: 255);
    return Color.fromRGBO(red, green, blue, opacity);
  }

  static int getRandom({int min = 0, required int max}) {
    return min + Random().nextInt(max - min + 1);
  }
}

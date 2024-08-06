import 'package:image/image.dart';
import 'package:nothing/common/constants.dart';

import '../../common/tools.dart';

class Gomoku extends StatefulWidget {
  const Gomoku({super.key});

  @override
  State<Gomoku> createState() => _GomokuState();
}

enum PointState {
  none,
  black,
  white,
}

class _GomokuState extends State<Gomoku> {
  List<List<PointState>> pointList = [];

  bool _isBlack = true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 15; i++) {
      pointList.add([]);
      for (int j = 0; j < 15; j++) {
        pointList[i].add(PointState.none);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tools.stopGift();
  }

  Point? temp;
  bool gameOver = false;

  void tapPoint(int dx, int dy) {
    if (gameOver) {
      // showToast('game over!');
      Tools.startGift();
      return;
    }

    assert(dx < 15 && dy < 15, 'point error');
    PointState state = pointList[dx][dy];
    if (state == PointState.none) {
      temp = Point(dx.toDouble(), dy.toDouble());
      if (_isBlack) {
        pointList[dx][dy] = PointState.black;
      } else {
        pointList[dx][dy] = PointState.white;
      }
      _isBlack = !_isBlack;

      if (gameIsOver(dx, dy)) {
        showToast('game over');
        gameOver = true;
        Tools.startGift();
      } else {
        gameOver = false;
      }

      setState(() {});
    }
  }

  bool gameIsOver(int dx, int dy) {
    PointState currentState = pointList[dx][dy];

    /// 水平方向
    int sum = 1;
    int tempX = dx;
    while (tempX > 0) {
      tempX--;
      if (pointList[tempX][dy] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }
    tempX = dx;
    while (tempX < 15) {
      tempX++;
      if (pointList[tempX][dy] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }

    /// 竖直方向
    sum = 1;
    int tempY = dy;
    while (tempY > 0) {
      tempY--;
      if (pointList[dx][tempY] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }
    tempY = dy;
    while (tempY < 15) {
      tempY++;
      if (pointList[dx][tempY] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }

    /// y=x方向
    sum = 1;
    int tempXX = dx;
    int tempXY = dy;
    while (tempXX > 0 && tempXY < 15) {
      tempXX--;
      tempXY++;
      if (pointList[tempXX][tempXY] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }

    tempXX = dx;
    tempXY = dy;
    while (tempXX < 15 && tempXY > 1) {
      tempXX++;
      tempXY--;
      if (pointList[tempXX][tempXY] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }

    /// y=-x方向
    sum = 1;
    int tempYX = dx;
    int tempYY = dy;
    while (tempXX > 1 && tempXY > 1) {
      tempYX--;
      tempYY--;
      if (pointList[tempYX][tempYY] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }

    tempYX = dx;
    tempYY = dy;
    while (tempYX <= 15 && tempYY <= 15) {
      tempYX++;
      tempYY++;
      if (pointList[tempYX][tempYY] == currentState) {
        sum++;
        if (sum == 5) {
          return true;
        }
      } else {
        break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (pointList.isEmpty) {
      return const SizedBox.shrink();
    }

    double sp = MediaQuery.of(context).size.width / 14;

    return Tools.giftWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: _isBlack ? Colors.black : Colors.grey,
            ),
          ),
          actions: [
            if (temp != null && !gameOver)
              IconButton(
                onPressed: () {
                  setState(() {
                    pointList[temp!.x.toInt()][temp!.y.toInt()] = PointState.none;
                    _isBlack = !_isBlack;
                    temp = null;
                  });
                },
                icon: const Icon(
                  Icons.replay_circle_filled_rounded,
                  color: Colors.green,
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Listener(
                  onPointerDown: (detail) {
                    double tX = detail.localPosition.dx / sp;
                    double tY = detail.localPosition.dy / sp;

                    double tempX = tX % 1;
                    double tempY = tY % 1;
                    if (0.3 < tempX && tempX < 0.7) {
                      return;
                    } else if (0.3 < tempY && tempY < 0.7) {
                      return;
                    }

                    int dx = tX.round();
                    int dy = tY.round();
                    tapPoint(dx, dy);
                  },
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
                    painter: PanelCustomPainter(pointList: pointList),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PanelCustomPainter extends CustomPainter {
  PanelCustomPainter({required this.pointList}) : super();
  final List<List<PointState>> pointList;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey
      ..strokeWidth = 1;

    double sp = size.width / 14;

    for (int i = 0; i < 15; i++) {
      canvas.drawLine(Offset(sp * i, 0), Offset(sp * i, size.height), paint);
      canvas.drawLine(Offset(0, sp * i), Offset(size.width, sp * i), paint);
    }

    double pointR = 20;

    Paint paintWhite = Paint()..color = Colors.grey;

    Paint paintBlack = Paint()..color = Colors.black;

    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 15; j++) {
        PointState state = pointList[i][j];
        if (state == PointState.black) {
          canvas.drawOval(Rect.fromCenter(center: Offset(i * sp, j * sp), width: pointR, height: pointR), paintBlack);
        } else if (state == PointState.white) {
          canvas.drawOval(Rect.fromCenter(center: Offset(i * sp, j * sp), width: pointR, height: pointR), paintWhite);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PanelCustomPainter oldDelegate) {
    return pointList != oldDelegate.pointList || true;
  }
}

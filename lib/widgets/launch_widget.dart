//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-20 12:09:13
//
import 'package:flutter/material.dart';
import 'package:nothing/constants/screens.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LaunchWidget extends StatelessWidget {
  final String? title;
  final String? localPath;
  final String? url;

  final String? dayStr;
  final String? monthStr;
  final String? dateDetailStr;

  final String? contentStr;
  final String? author;

  //二维码
  final String? codeStr;

  const LaunchWidget(
      {Key? key,
      this.localPath,
      this.url,
      this.title,
      this.dayStr,
      this.monthStr,
      this.dateDetailStr,
      this.contentStr,
      this.author,
      this.codeStr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          localPath != null
              ? Image.asset(
                  localPath ?? '',
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.network(
                  url ?? '',
                  fit: BoxFit.fitHeight,
                  width: double.infinity,
                  height: double.infinity,
                ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 630.w,
              height: 1120.h,
              child: CustomPaint(
                painter: _BackPainter(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 64.h,
                      child: Center(
                        child: Text(
                          title ?? '',
                          style:
                              TextStyle(fontSize: 26.sp, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 556.w,
                      height: 548.h,
                      child: localPath != null
                          ? Image.asset(
                              localPath!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              url!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),
                    37.hSizedBox,
                    Row(
                      children: [
                        60.wSizedBox,
                        Text(
                          dayStr ?? '',
                          style:
                              TextStyle(color: Colors.black, fontSize: 78.sp),
                        ),
                        18.wSizedBox,
                        Container(
                          width: 2,
                          height: 78.h,
                          color: Colors.black,
                        ),
                        18.wSizedBox,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              monthStr ?? '',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 46.sp),
                            ),
                            Text(
                              dateDetailStr ?? '',
                              style: TextStyle(
                                  fontSize: 22.sp, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ],
                    ),
                    60.hSizedBox,
                    Padding(
                      padding: EdgeInsets.only(left: 62.w, right: 62.w),
                      child: Column(
                        children: [
                          Text(
                            contentStr ?? '',
                            style: TextStyle(
                                fontSize: 26.sp, fontWeight: FontWeight.w500),
                          ),
                          32.hSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                author ?? '',
                                style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 40.hSizedBox,
                    if (codeStr != null)
                      QrImage(
                        data: codeStr ?? '',
                        size: 120.w,
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BackPainter extends CustomPainter {
  final double radius = 18.h;
  final double firstRadiusTopHeight = 54.h;
  final double firstRadiusBottomHeight = 236.h;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    Path path = Path();

    //右边背景
    canvas.save();
    canvas.translate(size.width / 2, 0);
    path.moveTo(0, 0);
    path.lineTo(size.width / 2 - radius, 0);
    path.relativeArcToPoint(Offset(radius, radius),
        radius: Radius.circular(radius), largeArc: false, clockwise: false);
    path.relativeLineTo(0, firstRadiusTopHeight);
    path.relativeArcToPoint(Offset(0, radius * 2),
        radius: Radius.circular(radius), largeArc: false, clockwise: false);
    path.lineTo(size.width / 2,
        size.height - radius - firstRadiusBottomHeight - radius * 2);
    path.relativeArcToPoint(Offset(0, radius * 2),
        radius: Radius.circular(radius), largeArc: false, clockwise: false);
    path.relativeLineTo(0, firstRadiusBottomHeight);
    path.relativeArcToPoint(Offset(-radius, radius),
        radius: Radius.circular(radius), largeArc: false, clockwise: false);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    //左边镜像
    canvas.restore();
    canvas.save();
    canvas.scale(-1, 1);
    canvas.translate(-size.width / 2, 0);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BackPainter oldDelegate) {
    return oldDelegate != this;
  }
}

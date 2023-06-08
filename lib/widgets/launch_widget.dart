//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-20 12:09:13
//
import 'package:nothing/common/prefix_header.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LaunchWidget extends StatelessWidget {
  final String? title;
  final String image;
  final String? backgroundImage;

  final String? dayStr;
  final String? monthStr;
  final String? dateDetailStr;

  final String? contentStr;
  final String? author;

  //二维码
  final String? codeStr;

  const LaunchWidget(
      {Key? key,
      required this.image,
      this.backgroundImage,
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: backgroundImage ?? image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 315.w,
              height: 560.h,
              child: CustomPaint(
                painter: _BackPainter(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 32.h,
                      child: Center(
                        child: Text(
                          title ?? '',
                          style: TextStyle(fontSize: 13.sp, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 274.r,
                        height: 274.r,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                          height: double.infinity,
                        )),
                    18.hSizedBox,
                    Row(
                      children: [
                        30.wSizedBox,
                        Text(
                          dayStr ?? '',
                          style: TextStyle(color: Colors.black, fontSize: 36.sp),
                        ),
                        18.wSizedBox,
                        Container(
                          width: 1,
                          height: 39.h,
                          color: Colors.black,
                        ),
                        18.wSizedBox,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              monthStr ?? '',
                              style: TextStyle(color: Colors.black, fontSize: 23.sp),
                            ),
                            Text(
                              dateDetailStr ?? '',
                              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ],
                    ),
                    30.hSizedBox,
                    Padding(
                      padding: EdgeInsets.only(left: 31.w, right: 31.w),
                      child: Column(
                        children: [
                          Text(
                            contentStr ?? '',
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                          ),
                          16.hSizedBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                author ?? '',
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 40.hSizedBox,
                    if (codeStr != null)
                      QrImageView(
                        data: codeStr ?? '',
                        size: 60.w,
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
  final double radius = 9.h;
  final double firstRadiusTopHeight = 27.h;
  final double firstRadiusBottomHeight = 118.h;

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
    path.relativeArcToPoint(Offset(radius, radius), radius: Radius.circular(radius), largeArc: false, clockwise: false);
    path.relativeLineTo(0, firstRadiusTopHeight);
    path.relativeArcToPoint(Offset(0, radius * 2), radius: Radius.circular(radius), largeArc: false, clockwise: false);
    path.lineTo(size.width / 2, size.height - radius - firstRadiusBottomHeight - radius * 2);
    path.relativeArcToPoint(Offset(0, radius * 2), radius: Radius.circular(radius), largeArc: false, clockwise: false);
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

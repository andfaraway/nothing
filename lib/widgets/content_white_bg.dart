import 'package:nothing/common/prefix_header.dart';

class ContentWhiteBg extends StatelessWidget {
  final Widget? child;
  final double? height;
  final Color? color;

  const ContentWhiteBg({Key? key, this.child, this.height, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h, left: 25.w, right: 25.w),
      child: Container(
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10), boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A000000),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ]),
          child: child),
    );
  }
}

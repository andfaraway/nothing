import 'package:nothing/common/prefix_header.dart';

class ContentWhiteBg extends StatelessWidget {
  final Widget? child;
  final double? height;
  final Color? color;

  const ContentWhiteBg({Key? key, this.child, this.height, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.main,
      child: Container(
          height: height,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSize.radiusLarge),
              boxShadow: const <BoxShadow>[
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

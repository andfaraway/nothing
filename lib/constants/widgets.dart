import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineDivider extends StatelessWidget {
  const LineDivider({
    Key? key,
    this.thickness = 1,
    this.color,
    this.indent,
    this.endIndent,
  }) : super(key: key);

  final double thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness.w,
      height: thickness.w,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return _NoSplash(
      controller: controller,
      referenceBox: referenceBox,
      onRemoved: onRemoved,
    );
  }
}

class _NoSplash extends InteractiveInkFeature {
  _NoSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    VoidCallback? onRemoved,
  })  : assert(controller != null),
        assert(referenceBox != null),
        super(
        controller: controller,
        referenceBox: referenceBox,
        onRemoved: onRemoved,
        color: Colors.transparent,
      ) {
    controller.addInkFeature(this);
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}
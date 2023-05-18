import 'package:flutter/cupertino.dart';

typedef CustomHeaderBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final CustomHeaderBuilder builder;

  CustomHeaderDelegate({required this.minHeight, required this.maxHeight, required Widget child})
      : builder = ((ctx, shrinkOffset, overlapsContent) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  // CustomHeaderDelegate fixHeight 高度相同 构造函数
  CustomHeaderDelegate.fixHeight({required double height, required Widget child})
      : builder = ((context, shrinkOffset, overlapsContent) => child),
        minHeight = height,
        maxHeight = height,
        assert(height >= 0);

  CustomHeaderDelegate.builder({required this.minHeight, required this.maxHeight, required this.builder})
      : assert(minHeight <= maxHeight && minHeight >= 0);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    assert(() {
      if (child.key != null) {
        print('${child.key}: shrink: $shrinkOffset,overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxHeight || oldDelegate.minExtent != minHeight;
  }
}

import 'dart:math';

import 'package:nothing/prefix_header.dart';

import '../utils/image.dart';

class CustomExpandWidget extends StatefulWidget {
  final bool expand;
  final bool canExpand;
  final Widget titleWidget;
  final double subWidgetHeight;
  final Widget subWidget;
  final List<Widget>? actions;

  const CustomExpandWidget(
      {Key? key,
      this.expand = false,
      this.canExpand = true,
      required this.titleWidget,
      this.subWidgetHeight = 0,
      this.subWidget = const SizedBox.shrink(),
      this.actions})
      : super(key: key);

  @override
  State<CustomExpandWidget> createState() => _CustomExpandWidgetState();
}

class _CustomExpandWidgetState extends State<CustomExpandWidget>
    with SingleTickerProviderStateMixin {
  final Duration _animatedDuration = const Duration(milliseconds: 200);

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animatedDuration);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(7.r),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.canExpand
                        ? () {
                            _widgetExpand();
                          }
                        : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.r, vertical: 17.r),
                      color: scaffoldBackgroundColor
                          .withOpacity(widget.expand ? 1 : _controller.value),
                      child: Row(
                        children: [
                          Expanded(child: widget.titleWidget),
                          2.wSizedBox,
                          if (widget.canExpand)
                            Transform.rotate(
                              angle: pi / 2 * _controller.value,
                              child: ImageSvg.asset(R.imagesArrowRight,
                                  width: 7.r, height: 12.r),
                            ),
                          ...?widget.actions
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.expand
                        ? widget.subWidgetHeight
                        : widget.subWidgetHeight * _controller.value,
                    child: SingleChildScrollView(
                      child: SizedBox(
                          height: widget.subWidgetHeight,
                          child: widget.subWidget),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _widgetExpand() {
    if (_controller.value == 0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
}

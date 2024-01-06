import 'package:nothing/common/prefix_header.dart';

///创建一个可以拖拽悬停两边控件
class DragHoverBothSidesWidget extends StatefulWidget {
  final Offset offset;
  final Widget? child;
  final Widget? dragWidget;

  const DragHoverBothSidesWidget({
    super.key,
    this.offset = Offset.zero,
    this.child,
    required this.dragWidget,
  });

  @override
  State<StatefulWidget> createState() {
    return DragHoverBothSidesState();
  }
}

class DragHoverBothSidesState extends State<DragHoverBothSidesWidget> {
  DragIconModel? _dragIconModel = HiveBoxes.get(HiveKey.dragIconModel);

  final GlobalKey _myKey = GlobalKey();

  double _dx = 0;
  double _dy = 0;
  final Size _windowSize = Size(AppSize.screenWidth, AppSize.screenHeight);

  late final Size size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      size = _myKey.currentContext?.size ?? Size(88.r, 88.r);
      _dx = _dragIconModel?.dx ?? _windowSize.width - size.width;
      _dy = _dragIconModel?.dy ??
          _windowSize.height - size.height - AppSize.tabBarHeight;

      _dragIconModel ??= DragIconModel();
      // _dx = _windowSize.width - size.width;
      // _dy = _windowSize.height - size.height - AppSize.tabBarHeight;
      setState(() {});
    });
  }

  void dragEnd(DragEndDetails details) {
    HiveBoxes.put(HiveKey.dragIconModel, _dragIconModel);
  }

  void dragEvent(DragUpdateDetails details) {
    double currentX = details.globalPosition.dx - size.width / 2;
    double currentY = details.globalPosition.dy - size.height / 2;
    if (currentX > 0 && currentX < _windowSize.width - size.width) {
      _dx = currentX;
    }

    if (currentY > 0 &&
        currentY < _windowSize.height - size.height - AppSize.tabBarHeight) {
      _dy = currentY;
    }

    _dragIconModel
      ?..dx = _dx
      ..dy = _dy
      ..width = size.width
      ..height = size.height;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Positioned(
          key: _myKey,
          left: _dx,
          top: _dy,
          child: GestureDetector(
              // onVerticalDragEnd: dragEnd,
              // onHorizontalDragEnd: dragEnd,
              // onHorizontalDragUpdate: dragEvent,
              // onVerticalDragUpdate: dragEvent,
              onPanEnd: dragEnd,
              onPanUpdate: dragEvent,
              child: Container(child: widget.dragWidget)),
        ),
      ],
    );
  }
}

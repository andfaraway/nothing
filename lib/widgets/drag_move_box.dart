import 'package:nothing/common/prefix_header.dart';

///创建一个可以拖拽悬停两边控件
class DragHoverBothSidesWidget extends StatefulWidget {
  final Offset offset;
  final Widget? child;
  final Widget? dragWidget;
  final Size dragSize;

  const DragHoverBothSidesWidget({
    super.key,
    this.offset = Offset.zero,
    this.child,
    required this.dragWidget,
    required this.dragSize,
  });

  @override
  State<StatefulWidget> createState() {
    return DragHoverBothSidesState();
  }
}

class DragHoverBothSidesState extends State<DragHoverBothSidesWidget> {
  late DragIconModel _dragIconModel;

  final Size _windowSize = Size(AppSize.screenWidth, AppSize.screenHeight);

  @override
  void initState() {
    super.initState();
    _dragIconModel = HiveBoxes.get(
      HiveKey.dragIconModel,
      defaultValue: DragIconModel()
        ..dx = _windowSize.width - widget.dragSize.width
        ..dy = _windowSize.height - widget.dragSize.height - AppSize.tabBarHeight
        ..width = widget.dragSize.width
        ..height = widget.dragSize.height,
    );
  }

  void dragEnd(DragEndDetails details) {
    HiveBoxes.put(HiveKey.dragIconModel, _dragIconModel);
  }

  void dragEvent(DragUpdateDetails details) {
    double currentX = details.globalPosition.dx - widget.dragSize.width / 2;
    double currentY = details.globalPosition.dy - widget.dragSize.height / 2;
    if (currentX > 0 && currentX < _windowSize.width - widget.dragSize.width) {
      _dragIconModel.dx = currentX;
    }

    if (currentY > 0 && currentY < _windowSize.height - widget.dragSize.height - AppSize.tabBarHeight) {
      _dragIconModel.dy = currentY;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Positioned(
          left: _dragIconModel.dx,
          top: _dragIconModel.dy,
          child: GestureDetector(onPanEnd: dragEnd, onPanUpdate: dragEvent, child: Container(child: widget.dragWidget)),
        ),
      ],
    );
  }
}

import 'package:nothing/common/prefix_header.dart';

/// 可拖动容器
/// 拖动范围是父控件
class DragMoveBox extends StatefulWidget {
  final Size? size;
  final Offset? offset;
  final Widget? child;
  final Widget? dragWidget;

  const DragMoveBox({
    super.key,
    this.size,
    this.offset,
    this.child,
    required this.dragWidget,
  });

  @override
  State<DragMoveBox> createState() => _DragMoveBoxState();
}

class _DragMoveBoxState extends State<DragMoveBox> {
  DragIconModel _dragIconModel =
      HiveBoxes.get(HiveKey.dragIconModel, defaultValue: DragIconModel());

  final GlobalKey _myKey = GlobalKey();

  late Offset _currentOffset;

  //当前位移(有活动区域限制时，鼠标超过边界后当前位移不等于总位移，此时总位移可以确保回到边界内鼠标与控件的相对位置不变)
  late final ValueNotifier<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _dragIconModel = DragIconModel();
    _offset = ValueNotifier<Offset>(_dragIconModel.offset);
    _currentOffset = _offset.value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Align(
          alignment: Alignment.bottomRight,
          child: ValueListenableBuilder(
            valueListenable: _offset,
            builder: (context, offset, widget) => Transform.translate(
              key: _myKey,
              offset: offset,
              child: GestureDetector(
                child: this.widget.dragWidget,
                onPanUpdate: (detail) {
                  var off = _currentOffset = _currentOffset + detail.delta;
                  //拖动区域为父控件，去掉则不受限制，但拖出父控件会被遮挡无法点击。
                  //获取父控件大小
                  RenderBox? parentRenderBox = _myKey.currentContext
                          ?.findAncestorRenderObjectOfType<RenderObject>()
                      as RenderBox?;
                  Size? screenSize = parentRenderBox?.size;
                  //获取控件大小
                  final mySize = _myKey.currentContext?.size;
                  final renderBox =
                      _myKey.currentContext?.findRenderObject() as RenderBox?;
                  //获取控件当前位置
                  var originOffset = renderBox?.localToGlobal(Offset.zero);
                  if (originOffset != null) {
                    originOffset = parentRenderBox?.globalToLocal(originOffset);
                  }
                  if (screenSize == null ||
                      mySize == null ||
                      originOffset == null) {
                    return;
                  }
                  print('originOffset=$originOffset');
                  //计算不超出父控件区域
                  if (off.dx < -originOffset.dx) {
                    off = Offset(-originOffset.dx, off.dy);
                  } else if (off.dx >
                      screenSize.width - mySize.width - originOffset.dx) {
                    off = Offset(
                      screenSize.width - mySize.width - originOffset.dx,
                      off.dy,
                    );
                  }
                  if (off.dy < -originOffset.dy) {
                    off = Offset(off.dx, -originOffset.dy);
                  } else if (off.dy >
                      screenSize.height - mySize.height - originOffset.dy) {
                    off = Offset(
                      off.dx,
                      screenSize.height - mySize.height - originOffset.dy,
                    );
                  }
                  //现在活动区域为父控件 --end
                  _offset.value = off;
                },
                onPanEnd: (detail) {
                  _dragIconModel
                    ..dx = _offset.value.dx
                    ..dy = _offset.value.dy;
                  HiveBoxes.put(HiveKey.dragIconModel, _dragIconModel);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///创建一个可以拖拽悬停两边控件
class DragHoverBothSidesWidget extends StatefulWidget {
  final Size size;
  final Offset offset;
  final Widget? child;
  final Widget? dragWidget;

  const DragHoverBothSidesWidget({
    super.key,
    this.size = const Size(44, 44),
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
  final DragIconModel _dragIconModel =
      HiveBoxes.get(HiveKey.dragIconModel, defaultValue: DragIconModel());

  final GlobalKey _myKey = GlobalKey();

  double _dx = 0;
  double _dy = 0;
  final Size _windowSize = Size(AppSize.screenWidth, AppSize.screenHeight);

  @override
  void initState() {
    super.initState();
    _dx = 0;
    _dy = _windowSize.height - widget.size.height - AppSize.tabBarHeight;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final mySize = _myKey.currentContext?.size;
      print('mySize=$mySize');
    });
  }

  void dragEnd(DragEndDetails details) {
    if (_dx + widget.size.width / 2 < _windowSize.width / 2) {
      _dx = 0;
    } else {
      _dx = _windowSize.width - widget.size.width;
    }
    if (_dy + widget.size.height > _windowSize.height) {
      _dy = _windowSize.height - widget.size.height;
    } else if (_dy < 0) {
      _dy = 0;
    }
    setState(() {});
  }

  void dragEvent(DragUpdateDetails details) {
    _dx = details.globalPosition.dx - widget.size.width / 2;
    _dy = details.globalPosition.dy - widget.size.height / 2;
    print(_dy);
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
              onVerticalDragEnd: dragEnd,
              onHorizontalDragEnd: dragEnd,
              onHorizontalDragUpdate: dragEvent,
              onVerticalDragUpdate: dragEvent,
              child: widget.dragWidget),
        ),
        Positioned(
            left: _dx,
            top: _dy,
            child: Container(
              width: widget.size.width,
              height: widget.size.height,
              color: AppColor.red,
            ))
      ],
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nothing/common/prefix_header.dart';

class FunnyColors extends StatefulWidget {
  const FunnyColors({super.key});

  @override
  State<FunnyColors> createState() => _FunnyColorsState();
}

class _FunnyColorsState extends State<FunnyColors> {
  List<String> _models = const ['default', 'ui'];
  late String _model;
  List<String> _colors = const [];
  final List<String> _initColors = ['#6a2c70', '', '', '', '#f9ed69'];

  ValueNotifier<bool> _requesting = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _model = _models.first;
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _requesting.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHideOnTap(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppWidget.appbar(title: 'funny colors'),
        body: Padding(
          padding: AppPadding.main,
          child: Column(children: [
            _modelsWidget(),
            21.hSizedBox,
            _initColorWidget(),
            21.hSizedBox,
            _contentWidget(),
            Expanded(
              child: Center(
                child: _confirmWidget(),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _modelsWidget() {
    return Row(
      children: [
        Text(
          'model:',
          style: AppTextStyle.titleMedium,
        ),
        24.wSizedBox,
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 1), borderRadius: BorderRadius.circular(7)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  _model,
                  style: AppTextStyle.titleMedium,
                ),
                items: _models
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: _model,
                onChanged: (String? value) {
                  setState(() {
                    _model = value ?? _model;
                  });
                },
                dropdownStyleData: DropdownStyleData(
                  // width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    // color: Colors.redAccent,
                  ),
                  offset: const Offset(0, -1),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _initColorWidget() {
    return Row(
      children: List.generate(_initColors.length, (index) {
        final ValueNotifier<Color?> bgColor = ValueNotifier(_initColors[index].toColor());
        return Flexible(
          child: ValueListenableBuilder(
              valueListenable: bgColor,
              builder: (context, color, child) {
                return TextField(
                  controller: TextEditingController(text: _initColors[index]),
                  style: AppTextStyle.labelLarge.copyWith(color: color?.adaptiveColor),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: _initColors[index].toColor(),
                    filled: true,
                    hintText: 'undefine',
                    hintStyle: AppTextStyle.labelLarge.copyWith(color: AppColor.disabledColor),
                  ),
                  onChanged: (value) {
                    _initColors[index] = value;
                    bgColor.value = value.toColor();
                  },
                );
              }),
        );
      }),
    );
  }

  Widget _contentWidget() {
    double radius = 15;
    return SizedBox(
      height: 150,
      child: Row(
        children: List.generate(_colors.length, (index) {
          String color = _colors[index];
          return Flexible(
            child: GestureDetector(
              onLongPress: () async {
                bool s = await Tools.copyString(color);
                if (s) {
                  showToast('已复制 $color', gravity: ToastGravity.CENTER);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                      color: color.toColor(),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(index == 0 ? radius : 0),
                        bottomLeft: Radius.circular(index == 0 ? radius : 0),
                        topRight: Radius.circular(index == _colors.length - 1 ? radius : 0),
                        bottomRight: Radius.circular(index == _colors.length - 1 ? radius : 0),
                      ),
                    ),
                  )),
                  5.hSizedBox,
                  Text(
                    color,
                    style: AppTextStyle.bodyMedium,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _confirmWidget() {
    return ValueListenableBuilder(
        valueListenable: _requesting,
        builder: (context, requesting, child) {
          return requesting
              ? SpinKitPouringHourGlass(
                  color: '#febc8b'.toColor()!,
                  size: 54,
                )
              : InkWell(
                  onTap: () async {
                    _requesting.value = true;
                    hideKeyboard(context);
                    List<String> tempList = [];
                    for (var element in _initColors) {
                      tempList.add(element.isNotEmpty ? element : 'N');
                    }
                    if (tempList.where((element) => element != 'N').isEmpty) {
                      tempList.clear();
                    }
                    await API.getBeautifulColors(model: _model, colors: tempList).then((value) {
                      if (value.isSuccess) {
                        _colors = value.dataList.cast<String>();
                        setState(() {});
                      }
                    });
                    _requesting.value = false;
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.greenAccent),
                    child: Text(
                      'go',
                      style: AppTextStyle.displayLarge.copyWith(color: Colors.white),
                    ),
                  ),
                );
        });
  }

  Future<void> _loadData() async {
    await API.getColorModels().then((value) {
      if (value.isSuccess) {
        _models = value.dataList.cast<String>();
        setState(() {});
      }
    });
  }
}

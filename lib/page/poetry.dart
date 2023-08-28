import 'dart:async';

import 'package:nothing/common/prefix_header.dart';

import '../model/poetry_model.dart';

/// 诗歌
class PoetryPage extends StatefulWidget {
  final Object? arguments;

  const PoetryPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  String? text;

  final List<PoetryModel> _poetries = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardHideOnTap(
      child: Scaffold(
        appBar: AppWidget.appbar(title: 'Poetry'),
        // backgroundColor: Colors.white,
        body: Container(
          padding: AppPadding.main,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [_searchBar(), 17.hSizedBox, _searchResultWidget()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      // controller: TextEditingController(text: _initColors[index]),
      style: AppTextStyle.titleMedium,
      textAlign: TextAlign.center,

      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide.none,
        ),
        constraints: BoxConstraints(maxHeight: 40.h),
        fillColor: AppColor.disabledColor,
        contentPadding: EdgeInsets.zero,
        filled: true,
        hintText: '搜索',
        hintStyle: AppTextStyle.titleMedium.copyWith(color: AppColor.disabledColor, fontWeight: weightMedium),
      ),
      onChanged: (value) {
        if (_timer?.isActive == true) {
          _timer?.cancel();
        }
        _timer = Timer(
            const Duration(milliseconds: 500),
            () {
              _search(value);
              _timer?.cancel();
            }.throttle());
      },
    );
  }

  Widget _searchResultWidget() {
    return Column(
      children: _poetries
          .map((e) => Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
                margin: EdgeInsets.only(bottom: AppPadding.main.bottom),
                padding: AppPadding.cell,
                child: Row(
                  children: [
                    Text(
                      e.title ?? '',
                      style: AppTextStyle.bodyMedium,
                    ),
                    12.sizedBoxW,
                    Text(
                      e.author ?? '',
                      style: AppTextStyle.bodyMedium,
                    )
                  ],
                ),
              ))
          .toList(),
    );
  }

  Future<void> _loadData() async {
    AppResponse response = await API.getPoetry();
    if (response.isSuccess) {
      _poetries.clear();
      _poetries.addAll(response.dataList.map((e) => PoetryModel.fromJson(e)).toList());
      setState(() {});
    }
  }

  Future<void> _search(String keyword) async {
    AppResponse response = await API.getPoetry(keyword: keyword);
    if (response.isSuccess) {
      _poetries.clear();
      _poetries.addAll(response.dataList.map((e) => PoetryModel.fromJson(e)).toList());
      setState(() {});
    }
  }
}

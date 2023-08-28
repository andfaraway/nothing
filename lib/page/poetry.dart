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
  final List<PoetryModel> _poetries = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData(keyword: '李白');
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
        backgroundColor: Colors.white,
        body: Container(
          padding: AppPadding.main,
          width: double.infinity,
          child: Column(
            children: [
              _searchBar(),
              17.hSizedBox,
              Expanded(child: _searchResultWidget()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: TextEditingController(text: '李白'),
      style: AppTextStyle.titleMedium,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide.none,
        ),
        constraints: BoxConstraints(maxHeight: 40.h),
        fillColor: AppColor.scaffoldBackgroundColor,
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
    return SingleChildScrollView(
      child: Column(
        children: _poetries
            .map((e) => InkWell(
                  onTap: () {
                    setState(() {
                      e.expand = !e.expand;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color(0xFFEEF2FF),
                    ),
                    margin: EdgeInsets.only(bottom: AppPadding.main.bottom),
                    padding: AppPadding.cell,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.title ?? '',
                          style: AppTextStyle.bodyMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              e.dynasty ?? '',
                              style: AppTextStyle.labelLarge,
                            ),
                            8.wSizedBox,
                            Text(
                              e.author ?? '',
                              style: AppTextStyle.labelLarge.copyWith(color: AppColor.errorColor),
                            ),
                          ],
                        ),
                        if (e.expand)
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Text(
                              e.content ?? '',
                              style: AppTextStyle.titleMedium,
                            ),
                          )
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _loadData({String? keyword}) async {
    AppResponse response = await API.getPoetry(keyword: keyword);
    if (response.isSuccess) {
      _poetries.clear();
      _poetries.addAll(response.dataList.map((e) => PoetryModel.fromJson(e)).toList());
      setState(() {});
    }
  }

  Future<void> _search(String keyword) async {
    AppResponse response = await API.getPoetry(keyword: keyword, pageSize: 20);
    if (response.isSuccess) {
      _poetries.clear();
      _poetries.addAll(response.dataList.map((e) => PoetryModel.fromJson(e)).toList());
      setState(() {});
    }
  }
}

import 'dart:async';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/widgets/highlight_text_widget.dart';
import 'package:nothing/widgets/search_bar_widget.dart';

import '../model/poetry_model.dart';

/// 诗歌
class PoetryPage extends StatefulWidget {
  final Object? arguments;

  const PoetryPage({Key? key, this.arguments}) : super(key: key);

  @override
  State<PoetryPage> createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> with AutomaticKeepAliveClientMixin {
  final List<PoetryModel> _poetries = [];
  PoetryModel? _currentPoetry;
  String _keyword = '李白';

  @override
  void initState() {
    super.initState();
    _loadData(keyword: _keyword);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return KeyboardHideOnTap(
      child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Scaffold(
          backgroundColor: AppRoute.poetry.pageColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                SearchBarWidget(
                  initText: _keyword,
                  onChanged: (keyword) => _search(keyword),
                ),
                Expanded(
                    child: Stack(
                  children: [
                    Visibility(visible: _currentPoetry != null, child: _contentWidget(_currentPoetry)),
                    Visibility(
                      visible: isKeyboardVisible,
                      child: _searchResultWidget(),
                    ),
                  ],
                ))
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _searchResultWidget() {
    if (_poetries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 17.h),
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          PoetryModel model = _poetries[index];
          String originalText = '';
          if (_keyword.isNotEmpty && model.content.contains(_keyword)) {
            print('_keyword=$_keyword');
            RegExp regExp = RegExp(r'[^\。\！\？]*' + _keyword + r'[^\。\！\？]*[\。\！\？]');
            Iterable<Match> matches = regExp.allMatches(model.content);
            print('matches=${matches.firstOrNull?.group(0)}');
            String result = matches.map((match) => match.group(0)).join('\n');
            originalText = result;
          }

          return InkWell(
            onTap: () {
              hideKeyboard(context);
              setState(() {
                _currentPoetry = model;
              });
            },
            child: Container(
              padding: AppPadding.main.copyWith(bottom: 5, top: 5),
              color: AppColor.white.withOpacity(1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightTextWidget(
                    style: AppTextStyle.titleMedium.copyWith(fontWeight: weightBold),
                    originalText: model.title,
                    highlightRegexList: [_keyword],
                    highlightStyles: [AppTextStyle.titleMedium.copyWith(color: AppColor.specialColor)],
                  ),
                  HighlightTextWidget(
                    style: AppTextStyle.bodyMedium,
                    originalText: '${model.author} ${model.dynasty}《${model.book}》',
                    highlightRegexList: [_keyword],
                    highlightStyles: [AppTextStyle.titleMedium.copyWith(color: AppColor.specialColor)],
                  ),
                  HighlightTextWidget(
                    style: AppTextStyle.titleMedium,
                    originalText: originalText,
                    highlightRegexList: [_keyword],
                    highlightStyles: [AppTextStyle.titleMedium.copyWith(color: AppColor.specialColor)],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: _poetries.length,
        shrinkWrap: true,
      ),
    );
  }

  Widget _contentWidget(PoetryModel? model) {
    if (model == null) {
      return const SizedBox.shrink();
    }
    return DefaultTextStyle(
      style: AppTextStyle.titleMedium,
      child: Padding(
        padding: AppPadding.main,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppSize.tabBarHeight),
          child: Column(
            children: [
              Text(model.title),
              Text('${model.author} · ${model.dynasty} · 《${model.book}》'),
              17.hSizedBox,
              HighlightTextWidget(
                style: AppTextStyle.bodyLarge,
                originalText: model.contentDes,
                highlightRegexList: const [r'\((.*?)\)'],
                highlightStyles: [
                  AppTextStyle.labelLarge.copyWith(color: AppColor.specialColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadData({String? keyword}) async {
    AppResponse response = await API.getPoetry(keyword: keyword);
    if (response.isSuccess) {
      _poetries.clear();
      _poetries.addAll(response.dataList.map((e) => PoetryModel.fromJson(e)).toList());
      if (_poetries.isNotEmpty && keyword != null) {
        _currentPoetry = _poetries.firstWhereOrNull((element) => element.title.contains('蜀道难'));
      }
      setState(() {});
    }
  }

  Future<void> _search(String keyword) async {
    keyword = extractChineseCharacters(keyword);
    _keyword = keyword;
    if (keyword.isEmpty) return;
    AppResponse response = await API.getPoetry(keyword: keyword, pageSize: 100);
    if (response.isSuccess) {
      _poetries.clear();
      _poetries.addAll(response.dataList.map((e) => PoetryModel.fromJson(e)).toList());
      setState(() {});
    }
  }

  String extractChineseCharacters(String input) {
    // 使用正则表达式匹配中文字符
    RegExp regExp = RegExp(r'[\u4e00-\u9fa5]+');
    Iterable<Match> matches = regExp.allMatches(input);
    // 将匹配到的中文字符合并成一个字符串
    String chineseText = matches.map((match) => match.group(0)).join('');
    return chineseText;
  }

  @override
  bool get wantKeepAlive => true;
}
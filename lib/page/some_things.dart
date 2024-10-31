import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/exception_model.dart';
import 'package:nothing/widgets/custom_dropdown_button.dart';

import '../widgets/highlight_text_widget.dart';

class SomeThings extends StatefulWidget {
  const SomeThings({Key? key}) : super(key: key);

  @override
  State<SomeThings> createState() => _SomeThingsState();
}

class _SomeThingsState extends State<SomeThings> {
  late List<String> pagesName = [S.current.login, S.current.feedback, '错误收集'];
  String currentPage = S.current.login;
  List<RecordModel> _dataList = [];

  @override
  void initState() {
    super.initState();
  }

  final AppRefreshController _controller = AppRefreshController(autoRefresh: true);
  int pageIndex = 0;
  int pageSize = 10;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleWidget: SizedBox(
          width: 200,
          height: 50,
          child: LDropdownButton(
            items: pagesName.map((e) => CustomMenuItem(text: e)).toList(),
            initText: currentPage,
            onChanged: (value) async {
              currentPage = value ?? '';
              _controller.requestRefresh();
            },
          ),
        ),
      ),
      body: AppRefresher(
        onRefresh: _onRefresh,
        onLoading: _onLoad,
        controller: _controller,
        child: SingleChildScrollView(
          padding: AppPadding.main,
          child: Column(
            children: _dataList.map((e) => _cellWidget(e)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _cellWidget(RecordModel e) {
    return InkWell(
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    e.title ?? '',
                    style: AppTextStyle.bodyMedium,
                  ),
                ),
                Text(
                  e.trailingText ?? '',
                  style: AppTextStyle.bodyMedium,
                )
              ],
            ),
            Text(
              e.subTitle ?? '',
              style: AppTextStyle.labelLarge,
            ),
            if (e.expand)
              Visibility(
                visible: e.content != null,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: HighlightTextWidget(
                    style: AppTextStyle.titleMedium,
                    originalText: e.content ?? '',
                    highlightRegexList: const [
                      r'package:[\w/]+\.dart',
                      r'#\d+\s',
                      // r'══\S*?══', // 匹配类似 ══...══ 的特殊字符
                    ],
                    highlightStyles: [
                      // AppTextStyle.titleMedium.copyWith(color: Colors.red),
                      AppTextStyle.titleMedium.copyWith(color: Colors.red),
                      AppTextStyle.titleMedium.copyWith(color: Colors.blue), // 为特殊字符添加不同的样式
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    pageIndex = 0;
    await getData(pageIndex, pageSize, clean: true);
    setState(() {
      _controller.completed(success: true, resetFooterState: true);
    });
  }

  Future<void> _onLoad() async {
    pageIndex += 1;
    List<dynamic> data = await getData(pageIndex, pageSize, clean: false);
    _controller.completed(success: true, noMore: data.isEmpty);
    setState(() {});
  }

  Future<List<dynamic>> getData(int pageIndex, int pageSize, {bool clean = false}) async {
    if (clean) _dataList.clear();
    AppResponse response = AppResponse();
    if (currentPage == pagesName[0]) {
      response = await API.getLogins(pageIndex, pageSize);
      for (Map<String, dynamic> map in response.dataList) {
        RecordModel model = RecordModel(
            title: map['username'],
            subTitle: '${map['network']} ${map['battery']}\n${map['date'].toString().dateFormat(format: 'HH:mm:ss '
                'yyyy/MM/dd')} ',
            trailingText: map['version']);
        _dataList.add(model);
      }
    } else if (currentPage == pagesName[1]) {
      response = await API.getFeedback(pageIndex, pageSize);
      for (Map<String, dynamic> map in response.dataList) {
        print(' map = ${map['date']}');
        RecordModel model = RecordModel(
            title: map['nickname'],
            subTitle: map['date'].toString().dateFormat(
                format: 'HH:mm:ss '
                    'yyyy/MM/dd'),
            trailingText: map['version'],
            content: map['content'],
            expand: true);
        _dataList.add(model);
      }
    } else if (currentPage == pagesName[2]) {
      response = await API.getExceptions(pageIndex, pageSize);
      if (response.isSuccess) {
        for (Map<String, dynamic> map in response.dataList) {
          print(' map = ${map['date']}');

          ExceptionModel exceptionModel = ExceptionModel.fromJson(map);
          RecordModel model = RecordModel(
              title: exceptionModel.type,
              subTitle: exceptionModel.des,
              trailingText: exceptionModel.date.toString().dateFormat(format: 'yyyy/MM/dd HH:mm:ss'),
              content: exceptionModel.stack);
          _dataList.add(model);
        }
      }
    }
    return response.dataList;
  }
}

class RecordModel {
  String? icon;
  String? title;
  String? subTitle;
  String? trailingText;
  String? content;
  bool expand;

  RecordModel({this.icon, this.title, this.subTitle, this.trailingText, this.content, this.expand = false});
}

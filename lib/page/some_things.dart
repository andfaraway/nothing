import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/widgets/custom_dropdown_button.dart';

import '../http/http.dart';

class SomeThings extends StatefulWidget {
  const SomeThings({Key? key}) : super(key: key);

  @override
  State<SomeThings> createState() => _SomeThingsState();
}

class _SomeThingsState extends State<SomeThings> {
  late List<String> pagesName = [S.current.login, S.current.feedback];
  String currentPage = S.current.login;
  List<RecordModel> dataList = [];

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
      appBar: AppWidget.appbar(
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
        child: ListView.separated(
          padding: AppPadding.main,
          itemBuilder: (context, i) {
            RecordModel model = dataList[i];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: model.title == null
                  ? null
                  : Text(
                      model.title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
              subtitle: model.subTitle == null ? null : Text(model.subTitle!),
              trailing: model.trailingText == null
                  ? null
                  : Text(
                      model.trailingText!,
                      textAlign: TextAlign.center,
                    ),
            );
          },
          itemCount: dataList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
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
    if (clean) dataList.clear();
    List<dynamic> data = [];
    if (currentPage == pagesName[0]) {
      data = await API.getLogins(pageIndex, pageSize);
      for (Map<String, dynamic> map in data) {
        RecordModel model = RecordModel(
            title: map['username'],
            subTitle: '${map['network']} ${map['battery']}\n${map['date'].toString().dataFormat(format: 'HH:mm:ss '
                'yyyy/MM/dd')} ',
            trailingText: map['version']);
        dataList.add(model);
      }
    } else if (currentPage == pagesName[1]) {
      data = await API.getFeedback(pageIndex, pageSize);
      for (Map<String, dynamic> map in data) {
        RecordModel model = RecordModel(
            title: map['nickname'],
            subTitle: '${map['content']}\n${map['date'].toString().dataFormat(format: 'HH:mm:ss '
                'yyyy/MM/dd')}',
            trailingText: map['version']);
        dataList.add(model);
      }
    }
    return data;
  }

  Future<List<dynamic>> getCommonData(String table, int pageIndex, int pageSize, {bool clean = false}) async {
    if (clean) dataList.clear();
    Map<String, dynamic> params = {"table": table, "page": pageIndex, "size": pageSize};
    List<dynamic> response = await Http.get('/getCommonInfo', params: params);
    for (Map<String, dynamic> map in response) {
      String str = '';
      for (int i = 0; i < map.keys.length; i++) {
        String key = map.keys.elementAt(i);
        str += '$key:${map[key]}';
        if (i < map.keys.length - 1) {
          str += '\n';
        }
      }
      RecordModel model =
          RecordModel(title: str, trailingText: map['date'].toString().dataFormat(format: 'HH:mm:ss\nyyyy/MM/dd'));
      dataList.add(model);
    }
    return response;
  }
}

class RecordModel {
  String? icon;
  String? title;
  String? subTitle;
  String? trailingText;

  RecordModel({this.icon, this.title, this.subTitle, this.trailingText});
}
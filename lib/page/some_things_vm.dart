import 'package:nothing/prefix_header.dart';

import '../http/http.dart';

class SomeThingsVM extends BaseVM {
  SomeThingsVM(BuildContext context) : super(context);

  late List<String> pagesName;
  late String currentPage;
  List<RecordModel> dataList = [];

  @override
  void init() {
    pagesName = [S.current.login, S.current.feedback];
    currentPage = pagesName.first;
  }

  Future<List<dynamic>> getData(int pageIndex, int pageSize,
      {bool clean = false}) async {
    if (clean) dataList.clear();
    List<dynamic> data = [];
    if (currentPage == pagesName[0]) {
      data = await API.getLogins(pageIndex, pageSize);
      for (Map<String, dynamic> map in data) {
        RecordModel model = RecordModel(
            title: map['username'],
            subTitle:
                '${map['network']} ${map['battery']}\n${map['date'].toString().dataFormat(format: 'HH:mm:ss '
                    'yyyy/MM/dd')} ',
            trailingText: map['version']);
        dataList.add(model);
      }
    } else if (currentPage == pagesName[1]) {
      data = await API.getFeedback(pageIndex, pageSize);
      for (Map<String, dynamic> map in data) {
        RecordModel model = RecordModel(
            title: map['nickname'],
            subTitle:
                '${map['content']}\n${map['date'].toString().dataFormat(format: 'HH:mm:ss '
                    'yyyy/MM/dd')}',
            trailingText: map['version']);
        dataList.add(model);
      }
    }
    return data;
  }

  Future<List<dynamic>> getCommonData(String table, int pageIndex, int pageSize,
      {bool clean = false}) async {
    if (clean) dataList.clear();
    Map<String, dynamic> params = {
      "table": table,
      "page": pageIndex,
      "size": pageSize
    };
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
      RecordModel model = RecordModel(
          title: str,
          trailingText: map['date']
              .toString()
              .dataFormat(format: 'HH:mm:ss\nyyyy/MM/dd'));
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

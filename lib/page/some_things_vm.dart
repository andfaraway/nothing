import 'package:nothing/public.dart';

class SomeThingsVM extends BaseVM {
  SomeThingsVM(BuildContext context) : super(context);

  late List<String> pagesName;
  late String currentPage;
  List<RecordModel> dataList = [];

  @override
  void init() {
    pagesName = [S.current.some_things, S.current.feedback];
    currentPage = pagesName.first;
  }

  Future<List<dynamic>> getData(int pageIndex, int pageSize,
      {bool clean = false}) async {
    if (clean) dataList.clear();
    List<dynamic> data = [];
    if(currentPage == pagesName[0]){
      data = await API.getLogins(pageIndex, pageSize);
      for(Map<String,dynamic> map in data){
        RecordModel model = RecordModel(title: map['username'],subTitle: '${map['date'].toString().dataFormat(format: 'HH:mm:ss '
            'yyyy/MM/dd')} ${map['network']} ${map['battery']}',trailingText: map['version']);
        dataList.add(model);
      }
    }else if(currentPage == pagesName[1]){
      data = await API.getFeedback(pageIndex, pageSize);
      for(Map<String,dynamic> map in data){
        RecordModel model = RecordModel(title: map['nickname'],subTitle: '${map['content']}\n${map['date'].toString().dataFormat(format: 'HH:mm:ss '
            'yyyy/MM/dd')}',trailingText: map['version']);
        dataList.add(model);
      }
    }
    return data;
  }
}

class RecordModel {
  String? icon;
  String? title;
  String? subTitle;
  String? trailingText;

  RecordModel({this.icon,this.title,this.subTitle,this.trailingText});
}
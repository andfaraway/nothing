import 'package:nothing/base/base_widget.dart';
import 'package:nothing/public.dart';

class SomeThingsVM extends BaseVM {

  SomeThingsVM(BuildContext context) : super(context);

  List<dynamic> dataList = [];

  @override
  void init() {

  }

  Future<List<dynamic>> getData(int pageIndex,int pageSize,{bool clean = false}) async{
    if(clean) dataList.clear();
    List<dynamic> data = await API.getLogins(pageIndex, pageSize);
    dataList.addAll(data);
    return data;
  }

  void menuClick(String? string){
    print('click $string');
  }
}


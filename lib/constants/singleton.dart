//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 15:41:28
//
import 'package:nothing/constants/constants.dart';
import 'package:nothing/model/user_info_model.dart';

UserInfoModel get currentUser => Singleton.currentUser;

set currentUser(UserInfoModel? user) {
  if (user == null) {
    return;
  }
  Singleton.currentUser = user;
}

class Singleton {
  Singleton._internal();

  factory Singleton(){
    return _instance;
  }

  static loadData() async{
    Map<String, dynamic>? map = await LocalDataUtils.getMap(KEY_USER_INFO);
    print(map);
    if(map != null){
      currentUser = UserInfoModel().fromJson(map);
    }
  }

  static late final Singleton _instance = Singleton._internal();

  late int flag;

  static UserInfoModel currentUser = UserInfoModel();

}

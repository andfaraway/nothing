//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 15:41:28
//
import 'package:nothing/model/models.dart';

UserInfo get currentUser => Singleton.currentUser;

set currentUser(UserInfo? user) {
  if (user == null) {
    return;
  }
  Singleton.currentUser = user;
}

class Singleton {
  Singleton._internal();

  factory Singleton() => _instance;

  static late final Singleton _instance = Singleton._internal();

  late int flag;

  static UserInfo currentUser = const UserInfo();

}


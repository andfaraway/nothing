//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 15:41:28
//

class Singleton {
  Singleton._internal();

  factory Singleton() => _instance;

  static late final Singleton _instance = Singleton._internal();

  late int flag;
}


typedef GetObject = Function(dynamic object);

const String NETWORK_CHANGE = 'NETWORK_CHAGE';
const String NETWORK_TIME_OUT = 'NETWORK_TIME_OUT';

class NotificationCenter {
  NotificationCenter._internal();

  // 工厂模式
  factory NotificationCenter() => _instance;

  static late final NotificationCenter _instance = NotificationCenter._internal();

  //创建Map来记录名称
  Map<String, dynamic> postNameMap = Map<String, dynamic>();

  late GetObject getObject;

  //添加监听者方法
  addObserver(String postName, object(dynamic object)) {
    postNameMap[postName] = null;
    getObject = object;
  }

  //发送通知传值
  postNotification(String postName, dynamic object) {
    //检索Map是否含有postName
    if (postNameMap.containsKey(postName)) {
      postNameMap[postName] = object;
      getObject(postNameMap[postName]);
    }
  }

  //移除通知
  removeNotification(String postName) {
    if (postNameMap.containsKey(postName)) {
      postNameMap.remove(postName);
    }
  }
}

//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-11 17:31:44

class InterfaceModel {
  final String? title;
  final String? url;
  final int? tag;

  InterfaceModel({this.title, this.url, this.tag});

  InterfaceModel fromJson(Map map) {
    return InterfaceModel(title: map['title'], url: map['url'] ,tag: map['tag']);
  }
}

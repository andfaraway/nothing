//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 16:40:14
//

part of 'models.dart';

/// 启动页model
///
/// [title] 顶部标题, [image] 中间图片,  [localPath] 本地图片地址,
/// [dayStr] 日期, [monthStr] 月份, [dateDetailStr] 日期详情,
/// [contentStr] 内容, [authorStr] 作者, [codeStr] 二维码字符串,
/// [date] 时间, [backgroundImage] 背景图片, [localBackgroundPath] 背景图片本地地址,

@HiveType(typeId: HiveAdapterTypeIds.launchInfo)
class LaunchInfo extends HiveObject {
  LaunchInfo({
    this.title,
    this.image,
    this.localPath,
    this.dayStr,
    this.monthStr,
    this.dateDetailStr,
    this.contentStr,
    this.authorStr,
    this.codeStr,
    this.date,
    this.backgroundImage,
    this.localBackgroundPath,
  });

  factory LaunchInfo.fromJson(Map<String, dynamic> json) {
    return LaunchInfo(
      title: json['title'],
      image: json['image'],
      localPath: json['localPath'],
      dayStr: json['dayStr'],
      monthStr: json['monthStr'],
      dateDetailStr: json['dateDetailStr'],
      contentStr: json['contentStr'],
      authorStr: json['authorStr'],
      codeStr: json['codeStr'],
      date: json['date'],
      backgroundImage: json['backgroundImage'],
      localBackgroundPath: json['localBackgroundPath'],
    );
  }

  @HiveField(0)
  String? title;
  @HiveField(1)
  String? image;
  @HiveField(2)
  String? localPath;
  @HiveField(3)
  String? dayStr;
  @HiveField(4)
  String? monthStr;
  @HiveField(5)
  String? dateDetailStr;
  @HiveField(6)
  String? contentStr;
  @HiveField(7)
  String? authorStr;
  @HiveField(8)
  String? codeStr;
  @HiveField(9)
  String? date;
  @HiveField(10)
  String? backgroundImage;
  @HiveField(11)
  String? localBackgroundPath;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'localPath': localPath,
      'dayStr': dayStr,
      'monthStr': monthStr,
      'dateDetailStr': dateDetailStr,
      'contentStr': contentStr,
      'authorStr': authorStr,
      'codeStr': codeStr,
      'date': date,
      'backgroundImage': backgroundImage,
      'localBackgroundPath': localBackgroundPath,
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

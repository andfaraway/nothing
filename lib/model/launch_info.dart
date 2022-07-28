//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 16:40:14
//

part of 'models.dart';

/// 启动页model
///
/// [launchType] 0.带时间默认框  1.纯图片 [title] 顶部标题, [image] 中间图片,
/// [dayStr] 日期, [monthStr] 月份, [dateDetailStr] 日期详情,
/// [contentStr] 内容, [authorStr] 作者, [codeStr] 二维码字符串,
/// [date] 时间, [backgroundImage] 背景图片,

@HiveType(typeId: HiveAdapterTypeIds.launchInfo)
class LaunchInfo extends HiveObject {
  LaunchInfo(
      {this.launchType,
      this.title,
      this.image,
      this.dayStr,
      this.monthStr,
      this.dateDetailStr,
      this.contentStr,
      this.authorStr,
      this.codeStr,
      this.date,
      this.backgroundImage,
      this.homePage,
      this.timeCount});

  factory LaunchInfo.fromJson(Map<String, dynamic> json) {
    return LaunchInfo(
        title: json['title'],
        image: json['image'],
        dayStr: json['dayStr'],
        monthStr: json['monthStr'],
        dateDetailStr: json['dateDetailStr'],
        contentStr: json['contentStr'],
        authorStr: json['authorStr'],
        codeStr: json['codeStr'],
        date: json['date'],
        backgroundImage: json['backgroundImage'],
        homePage: json['homePage'],
        launchType: json['launchType'],
        timeCount: json['timeCount']);
  }

  @HiveField(0)
  String? title;
  @HiveField(1)
  String? image;
  @HiveField(2)
  int? launchType;
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
  int? timeCount;
  @HiveField(12)
  String? homePage;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'dayStr': dayStr,
      'monthStr': monthStr,
      'dateDetailStr': dateDetailStr,
      'contentStr': contentStr,
      'authorStr': authorStr,
      'codeStr': codeStr,
      'date': date,
      'backgroundImage': backgroundImage,
      'homePage': homePage,
      'timeCount': timeCount,
      'launchType': launchType
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

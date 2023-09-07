import 'dart:convert';

import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/poetry_model.g.dart';

export 'package:nothing/generated/json/poetry_model.g.dart';

@JsonSerializable()
class PoetryModel {
  String title = '';
  String author = '';
  String book = '';
  String dynasty = '';
  String content = '';
  bool expand = false;

  String get contentDes {
    if (!(book.contains('唐诗') == true || book.contains('宋词') == true)) return content ?? '';

    if (content.isEmpty) return '';
    // 使用正则表达式将每两句之间插入一个换行符
    String modifiedText = content.replaceAllMapped(
      RegExp(r'[^。！？]+[。！？]+'), // 匹配每两句话之间的分隔符
      (match) {
        return '${match.group(0)}\n'; // 插入换行符
      },
    );
    modifiedText = modifiedText.replaceAll(')', ')\n').replaceAll(' ', '').replaceAll('\b', '');
    return modifiedText;
  }

  PoetryModel();

  factory PoetryModel.fromJson(Map<String, dynamic> json) => $PoetryModelFromJson(json);

  Map<String, dynamic> toJson() => $PoetryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

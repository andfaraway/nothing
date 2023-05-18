import 'package:nothing/generated/json/base/json_field.dart';
import 'package:nothing/generated/json/message_model.g.dart';

@JsonSerializable()
class MessageModel {
  MessageModel();

  factory MessageModel.fromJson(Map<String, dynamic> json) => $MessageModelFromJson(json);

  Map<String, dynamic> toJson() => $MessageModelToJson(this);

  int? id;
  String? date;
  String? title;
  String? content;
  int? type;
}

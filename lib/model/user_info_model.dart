//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-26 16:40:14
//

part of 'models.dart';

/// 用户model

@HiveType(typeId: HiveAdapterTypeIds.userInfo)
class UserInfoModel extends HiveObject {
  UserInfoModel({
    this.username,
    this.nickname,
    this.email,
    this.platform,
    this.userId,
    this.avatar,
    this.token,
    this.openId,
    this.accountType,
    this.signature,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      username: json['username'].toString().removeNull,
      nickname: json['nick_name'].toString().removeNull,
      email: json['email'].toString().removeNull,
      platform: json['platform'].toString().removeNull,
      userId: json['id'].toString().toString().removeNull,
      avatar: json['avatar'].toString().removeNull,
      token: json['token'].toString().removeNull,
      openId: json['openId'].toString().removeNull,
      accountType: json['account_type'].toString().removeNull,
      signature: json['signature'].toString().removeNull,
    );
  }

  @HiveField(0)
  String? username;
  @HiveField(1)
  String? nickname;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? platform;
  @HiveField(4)
  String? userId;
  @HiveField(5)
  String? avatar;
  @HiveField(6)
  String? token;
  @HiveField(7)
  String? openId;
  @HiveField(8)
  String? accountType;
  @HiveField(9)
  String? signature;

  bool get showLove => accountType == '11' || accountType == '111';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'nickname': nickname,
      'email': email,
      'platform': platform,
      'userId': userId,
      'avatar': avatar,
      'token': token,
      'openId': openId,
      'accountType': accountType,
      'signature': signature,
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:nothing/model/favorite_model.dart';
import 'package:nothing/generated/json/favorite_model.g.dart';
import 'package:nothing/model/message_model.dart';
import 'package:nothing/generated/json/message_model.g.dart';
import 'package:nothing/model/user_info_model.dart';
import 'package:nothing/generated/json/user_info_model.g.dart';

JsonConvert jsonConvert = JsonConvert();

class JsonConvert {

  T? convert<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return asT<T>(value);
  }

  List<T?>? convertList<T>(List<dynamic>? value) {
    if (value == null) {
      return null;
    }
    try {
      return value.map((dynamic e) => asT<T>(e)).toList();
    } catch (e, stackTrace) {
      print('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }

  List<T>? convertListNotNull<T>(dynamic value) {
    if (value == null) {
      return null;
    }
    try {
      return (value as List<dynamic>).map((dynamic e) => asT<T>(e)!).toList();
    } catch (e, stackTrace) {
      print('asT<$T> $e $stackTrace');
      return <T>[];
    }
  }
  T? asT<T extends Object?>(dynamic value) {
    if (value is T) {
      return value;
    }
		final String type = T.toString();
    try {
      final String valueS = value.toString();
      if (type == "String") {
        return valueS as T;
      } else if (type == "int") {
        final int? intValue = int.tryParse(valueS);
        if (intValue == null) {
          return double.tryParse(valueS)?.toInt() as T?;
        } else {
          return intValue as T;
        }      } else if (type == "double") {
        return double.parse(valueS) as T;
      } else if (type ==  "DateTime") {
        return DateTime.parse(valueS) as T;
      } else if (type ==  "bool") {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return JsonConvert.fromJsonAsT<T>(value);
      }
    } catch (e, stackTrace) {
      print('asT<$T> $e $stackTrace');
      return null;
    }
  } 
	//Go back to a single instance by type
	static M? _fromJsonSingle<M>(Map<String, dynamic> json) {
		final String type = M.toString();
		if(type == (FavoriteModel).toString()){
			return FavoriteModel.fromJson(json) as M;
		}
		if(type == (MessageModel).toString()){
			return MessageModel.fromJson(json) as M;
		}
		if(type == (UserInfoModel).toString()){
			return UserInfoModel.fromJson(json) as M;
		}

		print("$type not found");
	
		return null;
}

  //list is returned by type
	static M? _getListChildType<M>(List<Map<String, dynamic>> data) {
		if(<FavoriteModel>[] is M){
			return data.map<FavoriteModel>((Map<String, dynamic> e) => FavoriteModel.fromJson(e)).toList() as M;
		}
		if(<MessageModel>[] is M){
			return data.map<MessageModel>((Map<String, dynamic> e) => MessageModel.fromJson(e)).toList() as M;
		}
		if(<UserInfoModel>[] is M){
			return data.map<UserInfoModel>((Map<String, dynamic> e) => UserInfoModel.fromJson(e)).toList() as M;
		}

		print("${M.toString()} not found");
	
		return null;
}

  static M? fromJsonAsT<M>(dynamic json) {
		if(json == null){
			return null;
		}		if (json is List) {
			return _getListChildType<M>(json.map((e) => e as Map<String, dynamic>).toList());
		} else {
			return _fromJsonSingle<M>(json as Map<String, dynamic>);
		}
	}
}
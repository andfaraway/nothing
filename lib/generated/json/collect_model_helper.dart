import 'package:nothing/model/collect_model.dart';

collectModelFromJson(CollectModel data, Map<String, dynamic> json) {
	if (json['usr'] != null) {
		data.usr = json['usr'].toString();
	}
	return data;
}

Map<String, dynamic> collectModelToJson(CollectModel entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['usr'] = entity.usr;
	return data;
}
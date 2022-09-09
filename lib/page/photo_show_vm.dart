import 'dart:math';

import 'package:nothing/public.dart';

import '../model/server_image_model.dart';

class PhotoShowVM extends BaseVM {
  
  PhotoShowVM(BuildContext context) : super(context);


  List<ServerImageModel> data = [];

  late int initIndex = 3;
  @override
  void init() {
    // 优先设置的值，然后服务器获取的值
    String? catalog = HiveBoxes.get(HiveKey.photoSetting) ?? HiveBoxes.get(photoShowRoute.routeName);
    print(catalog);
    // String catalog = 'wedding_photo_z';
    getImages(catalog);
  }

  Future<void> getImages(String? catalog) async{
    var response = await API.getImages(catalog) ?? [];
    data.clear();
    for(Map<String,dynamic> map in response){
      ServerImageModel model = ServerImageModel.fromJson(map);
      model.imageUrl = '${model.prefix}${model.name}';
      data.add(model);
    }
    data.sort((a, b){
      return a.name!.compareTo(b.name!);
    });
    initIndex = await LocalDataUtils.get(HiveKey.photoShowIndex) ?? 3;
    widgetSetState();
  }
}


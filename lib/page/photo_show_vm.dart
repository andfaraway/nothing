import 'dart:math';

import 'package:nothing/public.dart';

import '../model/server_image_model.dart';

class PhotoShowVM extends BaseVM {

  final String catalog;

  PhotoShowVM(BuildContext context,this.catalog) : super(context);

  List<ServerImageModel> data = [];

  int initIndex = 3;
  @override
  void init() {
    getImages();
  }

  Future<void> getImages() async{
    var response = await API.getImages(catalog);
    data.clear();
    for(Map<String,dynamic> map in response){
      ServerImageModel model = ServerImageModel.fromJson(map);
      model.imageUrl = '${model.prefix}${model.name}';
      data.add(model);
    }
    // initIndex = Random().nextInt(data.length);
    widgetSetState();
  }
}


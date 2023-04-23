import 'package:nothing/page/photo_show.dart';
import 'package:nothing/prefix_header.dart';

import '../model/server_image_model.dart';

class PhotoShowVM extends BaseVM {
  PhotoShowVM(BuildContext context) : super(context);

  List<ServerImageModel> data = [];

  late int initIndex = 3;

  late String catalog = (widget as PhotoShow).arguments ?? '';

  @override
  void init() {
    getImages(catalog);
  }

  Future<void> getImages(String? catalog) async {
    var response = await API.getImages(catalog) ?? [];
    data.clear();
    for (Map<String, dynamic> map in response) {
      ServerImageModel model = ServerImageModel.fromJson(map);
      model.imageUrl = '${model.prefix}${model.name}';
      if (model.imageUrl!.contains('.')) {
        data.add(model);
      }
    }
    data.sort((a, b) {
      return a.name!.compareTo(b.name!);
    });
    initIndex = HiveBoxes.get(HiveKey.photoShowIndex, defaultValue: 0);
    widgetSetState();
  }

  void changeCatalog() {
    showEdit(context,  title: '情书',text: catalog, commitPressed: (value) {
      if (value != null || value != '') {
        if(catalog.contains(value) || value.toString().contains(catalog)){
          HiveBoxes.put(HiveKey.photoShowIndex, 0);
        }
        if(value == '~'){
          value = '';
        }
        getImages(value);
      }
    }, cancelPressed: () {

    },);
  }
}

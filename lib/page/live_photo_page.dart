//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-05-25 11:21:13
//
import 'dart:io';

import 'package:nothing/public.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:images_to_live_photo/images_to_live_photo.dart';

class LivePhotoPage extends StatefulWidget {
  const LivePhotoPage({Key? key}) : super(key: key);

  @override
  State<LivePhotoPage> createState() => _LivePhotoPageState();
}

class _LivePhotoPageState extends State<LivePhotoPage> {
  File? firstImage;
  File? secondImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Photo"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pickPhoto(0);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: firstImage != null
                        ? Image.file(firstImage!)
                        : Container(
                            color: Colors.green,
                            child: const Center(
                              child: Text(
                                'first photo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            height: double.infinity,
                          ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pickPhoto(1);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: secondImage != null
                        ? Image.file(secondImage!)
                        : Container(
                      color: Colors.cyan,
                      child: const Center(
                        child: Text(
                          'second photo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      height: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () async{
                  await create();
                },
                child: const Text(
                  'create',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> pickPhoto(int index) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      maxAssets: 1, requestType: RequestType.image,
      // pickerConfig: const AssetPickerConfig(),
    );
    if(result != null){
      if(index == 0){
        firstImage = await result.first.originFile;
      }else{
        secondImage = await result.first.originFile;
      }
      setState(() {

      });
    }
  }

  Future<void> create() async{
    if(firstImage == null || secondImage == null){
      showToast('please select photo');
      return;
    }

    print('start');
    String movPath = await platformChannel.invokeMethod("image_to_mov",
        secondImage!.path);
    print('movePath:$movPath');
    String result = await platformChannel.invokeMethod("create_live_photo",
        [firstImage!.path,movPath]);
    // var result = await ImagesToLivePhoto.create(firstImage!.path, secondImage!
    //     .path);
    // var result = await platformChannel.invokeMethod(ChannelKey
    //     .createLivePhoto,[firstImage!.path,secondImage!.path]);
    print('result = $result');
  }
}

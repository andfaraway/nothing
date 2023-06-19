//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-05-25 11:21:13
//
import 'package:live_photo_maker/live_photo_maker.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/utils/web_import.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'image_editor_widget.dart';

class LivePhotoPage extends StatefulWidget {
  const LivePhotoPage({Key? key}) : super(key: key);

  @override
  State<LivePhotoPage> createState() => _LivePhotoPageState();
}

class _LivePhotoPageState extends State<LivePhotoPage> {
  File? firstImage;
  File? secondImage;
  late int movWidth;
  late int movHeight;

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
                        ? AppImage.file(firstImage!)
                        : Container(
                            color: Colors.green,
                            height: double.infinity,
                            child: const Center(
                              child: Text(
                                'first photo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
                        ? AppImage.file(secondImage!)
                        : Container(
                            color: Colors.cyan,
                            height: double.infinity,
                            child: const Center(
                              child: Text(
                                'second photo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () async {
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
    final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
        ));
    if (result == null) {
      return;
    }

    dynamic imageFile = await result.first.originFile;
    if (!mounted) return;
    dynamic file =
        await AppRoute.pushPage(context, SimpleImageEditor(imageFile!));

    if (index == 0) {
      firstImage = file;
    } else {
      secondImage = file;
      movWidth = result.first.width;
      movHeight = result.first.height;
    }
    setState(() {});
  }

  Future<void> create() async {
    if (firstImage == null || secondImage == null) {
      showToast('please select photo');
      return;
    }
    EasyLoading.show(dismissOnTap: false);
    bool success = await LivePhotoMaker.create(
        firstImagePath: firstImage!.path, secondImagePath: secondImage!.path, width: movWidth, height: movHeight);
    EasyLoading.dismiss();
    if (success) {
      showToast(S.current.success);
    } else {
      showToast(S.current.fail);
    }
  }
}

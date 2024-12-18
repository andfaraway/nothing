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
  const LivePhotoPage({super.key});

  @override
  State<LivePhotoPage> createState() => _LivePhotoPageState();
}

class _LivePhotoPageState extends State<LivePhotoPage> {
  File? coverImage;
  File? contentImage;
  File? contentVoice;
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
                    child: coverImage != null
                        ? AppImage.file(coverImage!)
                        : Container(
                            color: Colors.green,
                            height: double.infinity,
                            child: const Center(
                              child: Text(
                                'Cover Image',
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
                    child: contentImage != null
                        ? Image.file(contentImage!)
                        : contentVoice != null
                            ? const Center(
                                child: Icon(Icons.play_circle, size: 88),
                              )
                            : Container(
                                color: Colors.cyan,
                                height: double.infinity,
                                child: const Center(
                                  child: Text(
                                    'Content',
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
        pickerConfig: AssetPickerConfig(
          maxAssets: 1,
          requestType: index == 0 ? RequestType.image : RequestType.common,
        ));
    if (result == null) {
      return;
    }

    movWidth = result.first.width;
    movHeight = result.first.height;

    File? pickFile = await result.first.originFile;
    if (!mounted || pickFile == null) return;

    if (fileIsVideo(pickFile.path)) {
      contentImage = null;
      contentVoice = pickFile;
      return;
    }

    pickFile = await AppRoute.pushPage(context, SimpleImageEditor(pickFile));

    if (index == 0) {
      coverImage = pickFile;
    } else {
      contentImage = pickFile;
      contentVoice = null;
    }
    setState(() {});
  }

  Future<void> pickVideo(int index) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.video,
        ));
    if (result == null) {
      return;
    }
    contentVoice = await result.first.originFile;
    setState(() {});
  }

  Future<void> create() async {
    if (coverImage == null || (contentImage == null && contentVoice == null)) {
      showToast('please select photo');
      return;
    }
    EasyLoading.show(dismissOnTap: false);
    bool success = await LivePhotoMaker.create(
        coverImage: coverImage!.path,
        imagePath: contentImage?.path,
        voicePath: contentVoice?.path,
        width: movWidth,
        height: movHeight);
    EasyLoading.dismiss();
    if (success) {
      showToast(S.current.success);
    } else {
      showToast(S.current.fail);
    }
  }

  bool fileIsVideo(String filePath) {
    final file = File(filePath);
    final extension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension)) {
      return false;
    } else if (['mp4', 'mkv', 'avi', 'mov', 'flv'].contains(extension)) {
      return true;
    } else {
      return false;
    }
  }
}

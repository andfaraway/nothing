import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/widgets/download_button.dart';

import '../model/file_model.dart';

class FontsSetting extends StatefulWidget {
  const FontsSetting({Key? key}) : super(key: key);

  @override
  State<FontsSetting> createState() => _FontsSettingState();
}

class _FontsSettingState extends State<FontsSetting> {
  final List<FileModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字体设置-test'),
      ),
      body: Consumer<ThemesProvider>(
        builder: (context, themesProvider, child) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              FileModel file = _dataList[index];
              bool isSelected = file.name == (themesProvider.fontFamily ?? AppTextStyle.fontFamilyNameDefault);
              return Container(
                decoration:
                    BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(AppSize.radiusMedium)),
                padding: AppPadding.main,
                margin: AppPadding.main,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      file.name ?? '',
                      style: AppTextStyle.titleMedium.copyWith(fontFamily: file.name),
                    )),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) {
                        return ScaleTransition(scale: anim, child: child);
                      },
                      child: DownloadButton(
                        key: isSelected ? UniqueKey() : null,
                        file: file,
                        isSelected: isSelected,
                        unSelectedOnTap: () {
                          themesProvider.fontFamily =
                              file.name == AppTextStyle.fontFamilyNameDefault ? null : file.name;
                          AppTextStyle.loadFont(name: themesProvider.fontFamily);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _dataList.length,
            // shrinkWrap: true,
          );
        },
      ),
    );
  }

  _loadData() async {
    AppResponse response = await API.getFiles('src/fonts/');
    if (response.isSuccess) {
      _dataList.clear();

      _dataList.add(FileModel()..name = AppTextStyle.fontFamilyNameDefault);

      _dataList.addAll(response.dataList.map((e) => FileModel.fromJson(e)).toList());
      _dataList.removeWhere((element) => element.isDir);

      setState(() {});
    }
  }
}

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
    print('font setting dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('字体设置'),
      ),
      body: Consumer<ThemesProvider>(
        builder: (context, themesProvider, child) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              FileModel file = _dataList[index];
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
                    DownloadButton(file: file),
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
    List<dynamic>? s = await API.getFiles('src/fonts/') ?? [];

    _dataList.clear();
    _dataList.add(FileModel()..name = 'default');

    _dataList.addAll(s.map((e) => FileModel.fromJson(e)).toList());
    _dataList.removeWhere((element) => element.name == '...');

    setState(() {});
  }
}

import 'package:nothing/common/prefix_header.dart';

class FontsSetting extends StatefulWidget {
  const FontsSetting({Key? key}) : super(key: key);

  @override
  State<FontsSetting> createState() => _FontsSettingState();
}

class _FontsSettingState extends State<FontsSetting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('字体'),
          ),
      body: Container(),
    );
  }
}

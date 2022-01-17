//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-02 15:42:01
//
import 'package:dio/dio.dart';
import 'package:nothing/constants/constants.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:nothing/widgets/photo_show_widget.dart';

class PhotoShow extends StatefulWidget {
  const PhotoShow({Key? key}) : super(key: key);

  @override
  _PhotoShowState createState() => _PhotoShowState();
}

class _PhotoShowState extends State<PhotoShow> {
  List urlsList = [];

  @override
  void initState() {
    super.initState();
    _requestData();
  }

  _requestData() async {
    Response response = await NetUtils.get('http://1.14.252.115:5000/images');
    Map data = response.data['data'];
    String baseImageUrl = 'http://1.14.252.115/src/';
    print(data);
    for (String key in data.keys) {
      if (data[key] is List) {
        List<String> list = data[key].cast<String>();
        List<String> urls = [];
        for (String url in list) {
          urls.add(baseImageUrl + key + '/' + url);
        }
        urlsList.add(urls);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: urlsList.isEmpty
          ? const Center(child: Text('wait'))
          : PageView(
              children: urlsList.map((urls) => PhotoShowWidget(urls)).toList(),
            ),
    );
  }
}

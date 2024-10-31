import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/page/video_screen.dart';

class VideoPlayPage extends StatefulWidget {
  const VideoPlayPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayPage> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlayPage> {
  String url = '${Config.netServer}/something/1.mp4';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Video Play',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: TextEditingController(text: url),
            onChanged: (value) {
              url = value;
            },
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              AppRoute.pushPage(context, VideoScreen(url: url));
            },
            child: const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text('next'),
            ),
          ),
        ],
      ),
    );
  }
}

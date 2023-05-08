import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/page/video_screen.dart';

import 'video_play_vm.dart';

class VideoPlayPage extends BasePage<_VideoPlayState> {
  const VideoPlayPage({Key? key}) : super(key: key);

  @override
  _VideoPlayState createBaseState() => _VideoPlayState();
}

class _VideoPlayState extends BaseState<VideoPlayVM, VideoPlayPage> {
  String url = '${ConstUrl.netServer}/something/1.mp4';

  @override
  VideoPlayVM createVM() => VideoPlayVM(context);

  @override
  void initState() {
    super.initState();
    pageTitle = "Video Play";
  }

  @override
  Widget createContentWidget() {
    return Column(
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
            Routes.pushPage(context, VideoScreen(url: url));
          },
          child: const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text('next'),
          ),
        ),
      ],
    );
  }
}

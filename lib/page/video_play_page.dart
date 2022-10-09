import 'dart:math';

import 'package:nothing/page/video_screen.dart';
import 'package:nothing/public.dart';
import 'package:video_player/video_player.dart';
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
            AppRoutes.pushPage(context, VideoScreen(url: url));
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

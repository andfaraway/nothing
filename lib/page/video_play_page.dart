import 'dart:math';

import 'package:nothing/public.dart';
import 'package:video_player/video_player.dart';
import 'video_play_vm.dart';

class VideoPlayPage extends BasePage<_VideoPlayState> {
  const VideoPlayPage({Key? key}) : super(key: key);

  @override
  _VideoPlayState createBaseState() => _VideoPlayState();
}

class _VideoPlayState extends BaseState<VideoPlayVM, VideoPlayPage> {
  late VideoPlayerController _controller;
  String url = 'http://1.14.252.115/something/1/1.mp4';
  int quarterTurns = 0;

  @override
  VideoPlayVM createVM() => VideoPlayVM(context);

  @override
  void initState() {
    super.initState();
    pageTitle = "Video Play";
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        print('load success');
        setState(() {});
      }).catchError((error) {
        print('load error:${error.toString()}');
      });
  }

  @override
  Widget? floatingActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: '1',
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
              pageTitle = null;
              backgroundColor = Colors.black;
              quarterTurns = 1;
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        FloatingActionButton(
          heroTag: '2',
          onPressed: () {
            _controller = VideoPlayerController.network(url)
              ..initialize().then((_) {
                print('load success');
                setState(() {});
              }).catchError((error) {
                print('load error:${error.toString()}');
              });
            setState(() {});
          },
          child: const Icon(Icons.rotate_left),
        ),
      ],
    );
  }

  @override
  Widget createContentWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_controller.value.isPlaying)
          TextField(
            controller: TextEditingController(text: url),
            onChanged: (value) {
              url = value;
            },
          ),
        _controller.value.isInitialized
            ? RotatedBox(
                quarterTurns: quarterTurns,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container(),
      ],
    );
  }
}

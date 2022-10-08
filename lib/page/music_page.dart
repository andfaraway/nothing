import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:nothing/public.dart';
import 'music_vm.dart';

class MusicPage extends BasePage<_MusicPageState> {
  const MusicPage({Key? key}) : super(key: key);

  @override
  _MusicPageState createBaseState() => _MusicPageState();
}

class _MusicPageState extends BaseState<MusicVM, MusicPage> {
  @override
  MusicVM createVM() => MusicVM(context);

  /// 播放状态  0.加载中 1.准备播放  2.暂停中  3.播放中
  final ValueNotifier<AudioPlayerState> playStatus =
      ValueNotifier(AudioPlayerState.loading);

  final player = AudioPlayer(); // Create a player

  @override
  void initState() {
    super.initState();
    pageTitle = "Music Play";
    loadMusic('http://1.14.252.115/music/badukongjian/bandaotiehe.mp3');
  }

  Future<void> loadMusic(String url) async {
    playStatus.value = AudioPlayerState.stopped;
    // final duration = await player.setUrl(url);
    // print('duration = $duration');

    try {
      final duration = await player.setAudioSource(AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: '1',
          album: "Album name",
          title: "Song name",
          artUri: null,
        ),
      ));
      print('duration = $duration');
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  /// 播放
  Future<void> play() async {
    await player.play();
    playStatus.value = AudioPlayerState.playing;
  }

  /// 暂停
  Future<void> pause() async {
    await player.pause();
    playStatus.value = AudioPlayerState.paused;
  }

  /// 恢复播放
  Future<void> resume() async {
    await player.play();
    playStatus.value = AudioPlayerState.playing;
  }

  @override
  Widget createContentWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                if (playStatus.value == AudioPlayerState.loading) {
                  return;
                } else if (playStatus.value == AudioPlayerState.stopped) {
                  await play();
                } else if (playStatus.value == AudioPlayerState.playing) {
                  await pause();
                } else if (playStatus.value == AudioPlayerState.paused) {
                  await resume();
                }
              },
              iconSize: 100,
              padding: EdgeInsets.zero,
              // splashColor: Colors.green,
              icon: ValueListenableBuilder(
                builder: (context, AudioPlayerState state, child) {
                  if (playStatus.value == AudioPlayerState.loading) {
                    return const CircularProgressIndicator();
                  } else if (playStatus.value == AudioPlayerState.stopped) {
                    return const Icon(
                      Icons.play_arrow,
                      color: Colors.red,
                    );
                  } else if (playStatus.value == AudioPlayerState.playing) {
                    return const Icon(
                      Icons.pause,
                      color: Colors.black,
                      size: 80,
                    );
                  } else if (playStatus.value == AudioPlayerState.paused) {
                    return const Icon(
                      Icons.play_arrow,
                      color: Colors.red,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
                valueListenable: playStatus,
              ),
            ),
          ],
        )
      ],
    );
  }
}

enum AudioPlayerState {
  loading, // 加载中
  stopped, // 初始状态，已停止或发生错误
  playing, // 正在播放
  paused, // 暂停
  completed // 播放结束
}

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/music_model.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late AudioPlayer _player;
  AudioPlayer? _sleepPlayer;

  PlayerState? playerState = PlayerState.stopped;

  Duration position = Duration.zero;

  Duration duration = Duration.zero;

  List<MusicModel> musicList = [];

  MusicModel? currentMusic;

  @override
  void initState() {
    super.initState();

    _init();

    request();
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  _init() {
    _player = AudioPlayer();

    _player.audioCache.prefix = '';

    _player.onDurationChanged.listen((Duration d) {
      duration = d;
      setState(() {});
    });

    _player.onPositionChanged.listen((Duration p) {
      position = p;
      setState(() {});
    });

    _player.onPlayerStateChanged.listen((PlayerState s) {
      playerState = s;
      setState(() {});
    });
  }

  play() async {
    if (currentMusic == null) {
      return null;
    }

    playerState = null;
    setState(() {});
    await _player.play(UrlSource(currentMusic!.url)).catchError((e) {});
  }

  pause() async {
    if (_player.state != PlayerState.playing) {
      return;
    }
    await _player.pause();
  }

  stop() async {
    if (_player.state != PlayerState.playing) {
      return;
    }
    await _player.stop();
  }

  playSleep() async {
    _sleepPlayer ??= AudioPlayer();
    if (_sleepPlayer?.state == PlayerState.playing) {
      await _sleepPlayer?.pause();
    } else {
      await pause();

      _sleepPlayer?.setReleaseMode(ReleaseMode.loop);
      await _sleepPlayer?.play(AssetSource(R.filesSleep));
    }
    setState(() {});
  }

  request() async {
    final result = await API.getMusicList(pageSize: 100);
    if (result.isSuccess) {
      List<dynamic> list = result.dataMap['music_list'] ?? [];
      musicList = list.map((e) => MusicModel.fromJson(e)).toList();
      if (list.isNotEmpty) {
        _player.setSource(UrlSource(musicList.first.url));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: DefaultAppBar(actions: [
        IconButton(
          onPressed: playSleep,
          icon: _sleepPlayer?.state == PlayerState.playing ? const Icon(Icons.pause) : const Icon(Icons.bed),
        ),
        IconButton(
          onPressed: request,
          icon: const Icon(Icons.refresh, color: Colors.green),
        ),
      ]),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200], // 添加背景颜色
        ),
        child: SingleChildScrollView(
          child: Column(
            children: musicList.map((e) {
              return SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () async {
                    currentMusic = e;
                    await play();
                  },
                  child: Card(
                    color: currentMusic == e ? AppColor.randomColors.first : Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(e.name),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: _playWidget(),
    );
  }

  Widget _playWidget() {
    Widget midBtn;
    if (playerState == null) {
      midBtn = const CircularProgressIndicator();
    } else if (playerState == PlayerState.playing) {
      midBtn = GestureDetector(onTap: pause, child: const Icon(Icons.pause, size: 48));
    } else {
      midBtn = GestureDetector(onTap: play, child: const Icon(Icons.play_arrow, size: 48));
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 12)]),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 48, height: 48, child: midBtn),
            ],
          ),
          ProgressBar(
            progress: position,
            buffered: duration,
            total: duration,
            onSeek: (duration) async {
              await _player.seek(duration);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/music_model.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final _player = AudioPlayer();

  PlayerState playerState = PlayerState.stopped;

  Duration position = Duration.zero;

  Duration duration = Duration.zero;

  List<MusicModel> musicList = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() {
    _player.audioCache.prefix = '';

    _player.onDurationChanged.listen((Duration d) {
      setState(() => duration = d);
    });

    _player.onPositionChanged.listen((Duration p) {
      setState(() => position = p);
    });

    _player.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => playerState = s);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  play({MusicModel? model}) async {
    if (model == null) {
      await _player.resume();
    } else {
      await _player.play(UrlSource(model.url));
    }
  }

  pause() async {
    await _player.pause();
  }

  stop() async {
    await _player.stop();
  }

  playSleep() async {
    if (playerState != PlayerState.playing) {
      _player.setSource(AssetSource(R.filesSleep));
      await _player.setReleaseMode(ReleaseMode.loop);
      play();
    } else {
      pause();
    }
  }

  request() async {
    final result = await API.getMusicList(pageSize: 100);
    if (result.isSuccess) {
      List<dynamic> list = result.dataMap['music_list'] ?? [];
      musicList = list.map((e) => MusicModel.fromJson(e)).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidget.appbar(actions: [
        IconButton(
          onPressed: playSleep,
          icon: playerState == PlayerState.playing ? const Icon(Icons.pause) : const Icon(Icons.bed),
        ),
        IconButton(
          onPressed: request,
          icon: const Icon(Icons.refresh, color: Colors.green),
        ),
      ]),
      body: SingleChildScrollView(
        child: Column(
          children: musicList.map((e) {
            return SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => play(model: e),
                child: Card(
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
    );
  }
}

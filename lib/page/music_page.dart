import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/music_model.dart';
import 'package:rxdart/rxdart.dart';

import 'music_common.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with AutomaticKeepAliveClientMixin {
  late AudioPlayer _player;
  final _playlist = ConcatenatingAudioSource(children: []);

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    Screens.updateStatusBarStyle(dark: true);
    _init();
  }

  Future<void> _init() async {
    if (!Constants.justAudioBackgroundInit) {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      );
      Constants.justAudioBackgroundInit = true;
    }

    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());

    _player.playbackEventStream.listen((event) {
      print('play event = $event');
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    await _player.setAudioSource(_playlist);

    _sub = AppMessage.addListener<ActionEvent>((event) {
      if (event.action == ActionType.playSleep) {
        _playSleep();
      }
    });

    final result = await API.getMusicList();
    if (result.isSuccess) {
      final list = result.dataMap['music_list'] ?? [];
      try {
        _playlist.addAll(list
            .map((e) {
              MusicModel model = MusicModel.fromJson(e);
              print('model.cover = ${model.cover},${model.cover.isNotEmpty}');
              return LockCachingAudioSource(
                Uri.parse(model.url),
                tag: MediaItem(
                  id: model.id,
                  album: model.album,
                  title: model.name,
                  artUri: model.cover.isNotEmpty ? Uri.parse(model.cover) : null,
                ),
              );
            })
            .cast<LockCachingAudioSource>()
            .toList());
      } catch (e, stackTrace) {
        // Catch load errors: 404, invalid url ...
        print("Error loading playlist: $e");
        print(stackTrace);
      }
    }
    _player.setLoopMode(LoopMode.all);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<HomeProvider>().actionType == ActionType.playSleep) {
        _playSleep();
      }
    });
  }

  _playSleep() {
    int index = _playlist.sequence.indexWhere((element) {
      MediaItem item = element.tag;
      return item.id.toString() == '115';
    });
    if (index != -1) {
      _player.seek(Duration.zero, index: index);
      _player.play();
      _player.setLoopMode(LoopMode.one);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _sub?.cancel();
    _sub = null;
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream => Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _player.positionStream,
      _player.bufferedPositionStream,
      _player.durationStream,
      (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppWidget.appbar(title: 'MUSIC PLAY'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<SequenceState?>(
              stream: _player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state!.currentSource!.tag as MediaItem;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: metadata.artUri != null
                            ? Center(child: Image.network(metadata.artUri.toString()))
                            : const SizedBox.shrink(),
                      ),
                    ),
                    Text(metadata.album!, style: Theme.of(context).textTheme.titleMedium),
                    Text(metadata.title),
                  ],
                );
              },
            ),
          ),
          ControlButtons(_player),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  _player.seek(newPosition);
                },
              );
            },
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              StreamBuilder<LoopMode>(
                stream: _player.loopModeStream,
                builder: (context, snapshot) {
                  final loopMode = snapshot.data ?? LoopMode.off;
                  const icons = [
                    Icon(Icons.repeat, color: Colors.grey),
                    Icon(Icons.repeat, color: Colors.orange),
                    Icon(Icons.repeat_one, color: Colors.orange),
                  ];
                  const cycleModes = [
                    LoopMode.off,
                    LoopMode.all,
                    LoopMode.one,
                  ];
                  final index = cycleModes.indexOf(loopMode);
                  return IconButton(
                    icon: icons[index],
                    onPressed: () {
                      _player.setLoopMode(cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
                    },
                  );
                },
              ),
              Expanded(
                child: Text(
                  "Playlist",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              StreamBuilder<bool>(
                stream: _player.shuffleModeEnabledStream,
                builder: (context, snapshot) {
                  final shuffleModeEnabled = snapshot.data ?? false;
                  return IconButton(
                    icon: shuffleModeEnabled
                        ? const Icon(Icons.shuffle, color: Colors.orange)
                        : const Icon(Icons.shuffle, color: Colors.grey),
                    onPressed: () async {
                      final enable = !shuffleModeEnabled;
                      if (enable) {
                        await _player.shuffle();
                      }
                      await _player.setShuffleModeEnabled(enable);
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 240.0,
            child: StreamBuilder<SequenceState?>(
              stream: _player.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final sequence = state?.sequence ?? [];
                return ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {
                    if (oldIndex < newIndex) newIndex--;
                    _playlist.move(oldIndex, newIndex);
                  },
                  children: [
                    for (var i = 0; i < sequence.length; i++)
                      Dismissible(
                        key: ValueKey(sequence[i]),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          child: const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        onDismissed: (dismissDirection) {
                          _playlist.removeAt(i);
                        },
                        child: Material(
                          color: i == state!.currentIndex ? Colors.grey.shade300 : null,
                          child: ListTile(
                            title: Text(sequence[i].tag.title as String),
                            onTap: () async {
                              await _player.seek(Duration.zero, index: i);
                              _player.play();
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: addCLick,
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  addCLick() async {
    _init();
    return;
    // _playlist.add(LockCachingAudioSource(
    //   Uri.parse(model.url),
    //   tag: MediaItem(
    //     id: model.id,
    //     album: test,
    //     title: 'test',
    //     artUri: model.cover.isNotEmpty ? Uri.parse(model.cover) : null,
    //   ),
    // ));
    // _player.seek(Duration.zero, index: 4);
    // _player.play();

    _playlist.clear();

    final result = await API.getMusicList();
    if (result.isSuccess) {
      final List<dynamic> list = result.dataMap['music_list'] ?? [];

      Map<String, dynamic> map = list.firstWhereOrNull((element) => element['id'] == '117');
      MusicModel model = MusicModel.fromJson(map);

      try {
        LockCachingAudioSource? temp;
        List<LockCachingAudioSource> l = list
            .map((e) {
              MusicModel model = MusicModel.fromJson(e);

              final result = LockCachingAudioSource(
                Uri.parse(model.url),
                tag: MediaItem(
                  id: model.id,
                  album: model.album,
                  title: model.name,
                  artUri: model.cover.isNotEmpty ? Uri.parse(model.cover) : null,
                ),
              );

              if (model.id == '117') {
                temp = result;
              }
              return result;
            })
            .cast<LockCachingAudioSource>()
            .toList();

        _playlist.add(temp!);
      } catch (_) {}
    }
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 54.0,
                height: 54.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x", style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
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

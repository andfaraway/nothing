import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {
  // mix in default seek callback implementations

  final _player = AudioPlayer(); // e.g. just_audio

// The most common callbacks:
// @override
// Future<void> play() => _player.play();
// @override
// Future<void> pause() => _player.pause();
// Future<void> stop() => _player.stop();
// Future<void> seek(Duration position) => _player.seek(position);
// Future<void> skipToQueueItem(int i) => _player.seek(Duration.zero);
}

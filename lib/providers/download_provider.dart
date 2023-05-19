part of 'providers.dart';

class DownloadProvider {
  static final List<DownloadTask> _tasks = [];

  static List<DownloadTask> get tasks => _tasks;

  static void addTask({required String url, required String? name, required String? savePath}) {
    if (name == null) {
      Log.e('addTask name is null');
      return;
    } else if (savePath == null) {
      Log.e('addTask savePath is null');
      return;
    }

    DownloadTask task = DownloadTask(url: url, name: name!, savePath: savePath!);
    task.startDownload();
    _tasks.add(task);
  }

  static void removeTask({DownloadTask? task, String? url}) {
    assert(!(task == null && url == null));
    assert(!(task != null && url != null));

    if (task != null) {
      _tasks.remove(task);
    } else {
      _tasks.removeWhere((element) => element.url == url);
    }
  }
}

class DownloadTask extends ChangeNotifier {
  final String url;
  final String savePath;
  final String name;
  double progress = 0.0;
  CancelToken cancelToken = CancelToken();

  DownloadTask({required this.url, required this.name, required this.savePath});

  Future<void> startDownload() async {
    String tempPath = '${savePath}_temp';
    bool requestCompleted = false;
    var s = await API.downloadFile(
        url: url,
        savePath: tempPath,
        onReceiveProgress: (receivedBytes, totalBytes, progress) async {
          if (requestCompleted) return;
          AppMessage.send(this..progress = progress);
        },
        cancelToken: cancelToken);
    requestCompleted = true;
    DownloadProvider.removeTask(task: this);
    Log.n('$name completed = $s');
    if (s == null) {
      progress = -1;
    } else {
      progress = 1;
      await File(tempPath).rename(savePath);
    }
    AppMessage.send(this..progress = progress);
  }

  Future<void> cancel() async {
    Log.w('$url cancel');
    cancelToken.cancel();
  }
}

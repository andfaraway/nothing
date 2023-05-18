part of 'providers.dart';

class DownloadProvider {
  static final List<DownloadTask> _tasks = [];

  static List<DownloadTask> get tasks => _tasks;

  static void addTask({required String url, required String? name, required String? savePath}) {
    if (name == null) {
      LogUtils.e('addTask name is null');
      return;
    } else if (savePath == null) {
      LogUtils.e('addTask savePath is null');
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
  bool isCompleted = false;
  CancelToken cancelToken = CancelToken();

  DownloadTask({required this.url, required this.name, required this.savePath});

  Future<void> startDownload() async {
    String tempPath = '${savePath}_';
    API.downloadFile(
        url: url,
        savePath: tempPath,
        onReceiveProgress: (receivedBytes, totalBytes, progress) async {
          this.progress = progress;
          if (progress == 1) {
            isCompleted = true;
            await File(tempPath).rename(savePath);
            DownloadProvider.removeTask(task: this);
          }
          AppMessage.send(this);
        },
        cancelToken: cancelToken);
  }

  Future<void> cancel() async {
    cancelToken.cancel();
    progress = -1;
    DownloadProvider.removeTask(task: this);
    AppMessage.send(this);
  }
}

part of 'providers.dart';

class DownloadProvider with ChangeNotifier {
  final List<DownloadTask> _tasks = [];

  List<DownloadTask> get tasks => _tasks;

  void addTask({required String url, required String name, required String savePath}) {
    DownloadTask task = DownloadTask(url: url, name: name, savePath: savePath);
    task.startDownload();
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask({DownloadTask? task, String? url}) {
    assert(!(task == null && url == null));
    assert(!(task != null && url != null));

    if (task != null) {
      _tasks.remove(task);
    } else {
      _tasks.removeWhere((element) => element.url == url);
    }
  }
}

class DownloadTask with ChangeNotifier {
  final String url;
  final String savePath;
  final String name;
  double progress = 0.0;
  bool isCompleted = false;
  void Function(bool)? completedCallback;
  CancelToken cancelToken = CancelToken();

  DownloadTask({required this.url, required this.name, required this.savePath});

  Future<void> startDownload() async {
    print('startDownload->$url');
    API.downloadFile(
        url: url,
        savePath: '$savePath/temp_$name',
        onReceiveProgress: (receivedBytes, totalBytes, progress) async {
          this.progress = progress;
          if (progress == 1) {
            isCompleted = true;
            await File('$savePath/temp_$name').rename('$savePath/$name');
            completedCallback?.call(true);
          } else {
            notifyListeners();
          }
        },
        cancelToken: cancelToken);
  }

  Future<void> cancel() async {
    cancelToken.cancel();
  }
}

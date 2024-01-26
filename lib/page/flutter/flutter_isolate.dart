import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nothing/common/screens.dart';

class FlutterIsolate extends StatefulWidget {
  const FlutterIsolate({super.key});

  @override
  State<FlutterIsolate> createState() => _FlutterIsolateState();
}

int sum = 0;

class _FlutterIsolateState extends State<FlutterIsolate> {
  String timeCount = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolate'),
      ),
      body: Center(
        child: InkWell(
          onTap: () async {
            DateTime beginTime = DateTime.now();
            await _begin();
            timeCount = '${DateTime.now().difference(beginTime).inMilliseconds}';
            setState(() {});
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              5.hSizedBox,
              Material(
                color: Colors.red[100],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('begin'),
                ),
              ),
              Text('总计用时:$timeCount ms,\n$sum')
            ],
          ),
        ),
      ),
    );
  }

  _begin() async {
    final s = await compute((message) {
      int count = 0;
      for (int i = 0; i < 1000000000; i++) {
        count += i;
      }
      return count;
    }, 'message');
    sum = s;
  }
}

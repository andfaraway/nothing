import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:nothing/public.dart';

import '../model/file_model.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  final List<FileModel>? files;
  final int index;

  VideoScreen({Key? key, required this.url, this.files, this.index = 0})
      : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();
  int quarterTurns = 0;
  int currentIndex = 0;

  // 页面加
  bool indexPlus = true;
  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    player.setDataSource(widget.url, autoPlay: true);
    player.addListener(() {
      print('state = ${player.value.state}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (update) async {
        if (widget.files == null) return;

        if (update.delta.dy < 0) {
          //上划
          indexPlus = true;
        } else {
          // 下滑
          indexPlus = false;
        }
      },
      onPanEnd: (pan) async {
        if (widget.files == null) return;
        if (indexPlus) {
          //上划
          currentIndex++;
          if (currentIndex > widget.files!.length - 1) {
            currentIndex = 0;
          }
        } else {
          // 下滑
          currentIndex--;
          if (currentIndex < 0) {
            currentIndex = widget.files!.length - 1;
          }
        }

        FileModel model = widget.files![currentIndex];
        String url = "${model.prefix}${model.catalog ?? ''}${model.name}";
        showToast('${model.name}');
        await player.reset();
        await player.setDataSource(url, autoPlay: true);

      },
      child: Scaffold(
        appBar: null,
        body: RotatedBox(
          quarterTurns: quarterTurns,
          child: Container(
            alignment: Alignment.center,
            child: FijkView(
              fit: quarterTurns == 0 ? FijkFit.contain : FijkFit.contain,
              player: player,
              color: Colors.black,
            ),
          ),
        ),
        floatingActionButton: IconButton(
          onPressed: () {
            if (quarterTurns < 3) {
              quarterTurns += 1;
            } else {
              quarterTurns = 0;
            }
            setState(() {});
          },
          icon: const Icon(
            Icons.rotate_right,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}

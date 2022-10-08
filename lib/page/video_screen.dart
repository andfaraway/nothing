import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  const VideoScreen({required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();
  int quarterTurns = 0;

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.url, autoPlay: true);
    player.addListener(() {
      print('state = ${player.value.state}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: quarterTurns != 0 ? null : AppBar(title: const Text("Video play")),
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
          }else{
            quarterTurns = 0;
          }
          setState(() {

          });
        },
        icon: const Icon(Icons.rotate_right,color: Colors.red,),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}

//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-02 17:22:00
//
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nothing/constants/screens.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../public.dart';

class PhotoShowWidget extends StatefulWidget {
  const PhotoShowWidget(this.urls, {Key? key}) : super(key: key);
  final List urls;

  @override
  _PhotoShowWidgetState createState() => _PhotoShowWidgetState();
}

class _PhotoShowWidgetState extends State<PhotoShowWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: Screens.width,
      height: Screens.height,
      child: Swiper(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, i) {
          return SizedBox(
              width: Screens.width,
              height: Screens.height,
              child: Center(
                  child: CachedNetworkImage(
                      imageUrl: widget.urls[i],
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (context, object, _) {
                        return const Text('这张保密');
                      })));
        },
        itemCount: widget.urls.length,
      ),
    );
  }
}

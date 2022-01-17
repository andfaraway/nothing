//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-11 17:41:19
//

import 'package:extended_text/extended_text.dart';
import 'constants/constants.dart';

typedef RequestCallback = Future<String> Function();

class SimplePage extends StatefulWidget {
  const SimplePage(
      {Key? key,
      this.title,
      this.backgroundColor,
      this.requestCallback,
      this.justify = false,
      this.initialRefresh = true})
      : super(key: key);

  final String? title;
  final Color? backgroundColor;
  final RequestCallback? requestCallback;
  final bool justify;
  final bool initialRefresh;

  @override
  _SimplePageState createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final RefreshController _controller;
  final double marginWidth = 30;
  String contentText = '';
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: widget.initialRefresh);
    backgroundColor = widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SmartRefresher(
          onRefresh: () async {
            String? str = await widget.requestCallback?.call();
            if (mounted) {
              setState(() {
                contentText = str ?? '';
                if (widget.justify && contentText.length > 15) {
                  contentText = '        ' + contentText;
                }
              });
            }
            _controller.refreshCompleted();
          },
          controller: _controller,
          child: Column(
            children: [
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    backgroundColor = getRandomColor();
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: Screens.navigationBarHeight,
                  child: Text(
                    widget.title ?? '',
                    style: TextStyle(
                        color: backgroundColor?.getAdaptiveColor, fontSize: 28),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: marginWidth,
                        right: 10,
                        bottom: Screens.navigationBarHeight),
                    child: GestureDetector(
                      onDoubleTap: () async {
                        var result = await UserAPI.addFavorite(contentText.trim().toString(),source: widget.title);
                        if(result != null){
                           showToast('收藏成功！');
                        }

                        // String text = contentText.trim().toString();
                        // if (!favoriteList.contains(text)) {
                        //   favoriteList.add(text);
                        //   bool s = await LocalDataUtils.setStringList(
                        //       Constants.keyFavoriteList, favoriteList);
                        //   if (s) {
                        //     showToast('收藏成功！');
                        //   } else {
                        //     showToast('收藏失败！');
                        //   }
                        // } else {
                        //   showToast('已收藏');
                        // }
                      },
                      child: ExtendedText(
                        contentText.isEmpty ? '' : contentText,
                        style: TextStyle(
                            color: backgroundColor?.getAdaptiveColor,
                            fontSize: 22),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

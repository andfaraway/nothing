//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-11 17:41:19
//

import 'package:extended_text/extended_text.dart';
import 'public.dart';

typedef RequestCallback = Future<String> Function();

class SimplePage extends StatefulWidget {
  const SimplePage(
      {Key? key,
      this.title,
      this.requestCallback,
      this.justify = false,
      this.initialRefresh = true})
      : super(key: key);

  final String? title;
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

  @override
  void initState() {
    super.initState();
    _controller = RefreshController(initialRefresh: widget.initialRefresh);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.informationBgColor,
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
                      provider.informationBgColor = getRandomColor();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Screens.navigationBarHeight,
                      child: Text(
                        widget.title ?? '',
                        style: TextStyle(
                            color:
                                provider.informationBgColor.getAdaptiveColor,
                            fontSize: 28),
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
                            var result = await API.addFavorite(
                                contentText.trim().toString(),
                                source: widget.title);
                            if (result != null) {
                              showToast('收藏成功！');
                            }
                          },
                          child: ExtendedText(
                            contentText.isEmpty ? '' : contentText,
                            style: TextStyle(
                                color: provider
                                    .informationBgColor.getAdaptiveColor,
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
      },
    );
  }
}

//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-11 17:41:19
//

import '../common/prefix_header.dart';

typedef RequestCallback = Future<String> Function();

class SimplePage extends StatefulWidget {
  const SimplePage(
      {Key? key,
      this.title,
      this.requestCallback,
      this.justify = false,
      this.initialRefresh = true,
      this.backgroundColor})
      : super(key: key);

  final String? title;
  final RequestCallback? requestCallback;
  final bool justify;
  final bool initialRefresh;
  final Color? backgroundColor;

  @override
  State<SimplePage> createState() => _SimplePageState();
}

class _SimplePageState extends State<SimplePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final AppRefreshController _controller;
  String contentText = '';

  @override
  void initState() {
    super.initState();
    _controller = AppRefreshController(autoRefresh: widget.initialRefresh);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ThemesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: widget.backgroundColor ?? provider.informationBgColor,
          body: SafeArea(
            child: AppRefresher(
              onRefresh: () async {
                String? str = await widget.requestCallback?.call();
                if (mounted) {
                  setState(() {
                    contentText = str ?? '';
                    if (widget.justify && contentText.length > 15) {
                      contentText = '      $contentText';
                    }
                  });
                }
                _controller.completed();
              },
              controller: _controller,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30, bottom: Screens.navigationBarHeight),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            AppResponse result =
                                await API.addFavorite(contentText.trim().toString(), source: widget.title);
                            if (result.isSuccess) {
                              showToast('收藏成功！');
                            }
                          },
                          child: Text(
                            '\t' * 8 + contentText.trim(),
                            style: TextStyle(color: provider.informationBgColor.adaptiveColor, fontSize: 22),
                            textAlign: TextAlign.start,
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

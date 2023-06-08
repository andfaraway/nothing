import 'package:nothing/common/prefix_header.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({
    Key? key,
    required this.url,
    this.title,
    this.keepAlive = false,
  })  : assert(url != null),
        assert(keepAlive != null),
        super(key: key);

  final String? url;
  final String? title;
  final bool? keepAlive;

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> with AutomaticKeepAliveClientMixin {
  /// 页面是否可以返回
  final ValueNotifier<bool> webCanGoBack = ValueNotifier(false);

  final ValueNotifier<int> _loadingProgress = ValueNotifier(0);

  String url = 'about:blank';

  @override
  bool get wantKeepAlive => widget.keepAlive ?? false;

  late WebViewController _webController;

  final ValueNotifier<bool> _webViewCanGoBack = ValueNotifier(false);
  final ValueNotifier<String?> _webViewTitle = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    url = (widget.url ?? url).trim();

    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            _loadingProgress.value = progress;
          },
          onPageStarted: (String url) async {
            print('onPageStarted=$url');
          },
          onPageFinished: (String url) async {
            _webViewTitle.value = await _webController.getTitle();
            _webViewCanGoBack.value = await _webController.canGoBack();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // 页面拦截
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  void dispose() {
    super.dispose();
    _webViewCanGoBack.dispose();
    _webViewTitle.dispose();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.title != null
          ? AppBar(
              title: widget.title != null
                  ? Text(widget.title ?? '')
                  : ValueListenableBuilder(
                      valueListenable: _webViewTitle,
                      builder: (context, title, child) => Text(title ?? ''),
                    ),
              leading: ValueListenableBuilder(
                  valueListenable: _webViewCanGoBack,
                  builder: (context, canGoBack, child) {
                    return Row(
                      children: [
                        if (canGoBack)
                          AppButton.backButton(
                            onTap: () async {
                              if (await _webController.canGoBack()) {
                                await _webController.goBack();
                                _webViewCanGoBack.value = await _webController.canGoBack();
                              } else {}
                            },
                          ),
                      ],
                    );
                  }),
              actions: [
                AppButton.closeButton(
                  onTap: () {
                    if (Navigator.of(context).canPop()) {
                      AppRoute.pop();
                    } else {
                      AppRoute.pushNamedAndRemoveUntil(context, AppRoute.root.name);
                    }
                  },
                ),
              ],
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: _loadingProgress,
                builder: (context, value, child) {
                  double progress = value / 100;
                  if (progress == 1) return const SizedBox.shrink();
                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    color: AppColor.specialColor,
                  );
                }),
            Expanded(child: WebViewWidget(controller: _webController)),
          ],
        ),
      ),
    );
  }
}

import 'package:nothing/constants/constants.dart';
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
  _AppWebViewState createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> with AutomaticKeepAliveClientMixin {

  final ValueNotifier<String> title = ValueNotifier<String>('');

  /// 页面是否可以返回
  final ValueNotifier<bool> webCanGoBack = ValueNotifier(false);

  String url = 'about:blank';

  bool useDesktopMode = false;

  String get urlDomain => Uri.parse(url).host;

  @override
  bool get wantKeepAlive => widget.keepAlive ?? false;

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    url = (widget.url ?? url).trim();
    title.value = (widget.title ?? title.value).trim();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
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
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: title.value.isNotEmpty
          ? AppBar(
              title: Text(widget.title ?? ''),
            )
          : null,
      body: WebViewWidget(controller: controller),

    );
  }
}

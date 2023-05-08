import 'package:nothing/common/prefix_header.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../generated/json/base/json_convert_content.dart';
import 'button.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key,
    this.arguments,
  }) : super(key: key);

  final Object? arguments;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final YBJFWebViewController _webViewController = YBJFWebViewController();

  @override
  void initState() {
    super.initState();

    _config();
  }

  @override
  void dispose() {
    super.dispose();

    _webViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: YBJFButton.backButton(
          color: AppColor.mainColor,
        ),
        title: ValueListenableBuilder(
          valueListenable: _webViewController.title,
          builder: (BuildContext context, String? value, Widget? widget) {
            return Text(value ?? '');
          },
        ),
      ),
      body: YBJFWebView(
        controller: _webViewController,
      ),
    );
  }

  void _config() {
    var obj = widget.arguments;
    String? url;
    if (obj is Map) {
      url = jsonConvert.convert<String>(obj['url']);
    }
    if (url != null) {
      _webViewController.loadUrl(url);
    }
  }
}

class YBJFWebView extends StatefulWidget {
  const YBJFWebView({
    super.key,
    this.url = '',
    this.controller,
  });

  final String url;
  final YBJFWebViewController? controller;

  @override
  State<YBJFWebView> createState() => _YBJFWebViewState();
}

class _YBJFWebViewState extends State<YBJFWebView> {
  YBJFWebViewController? _webViewController;

  YBJFWebViewController? get _effectiveController =>
      widget.controller ?? _webViewController;

  @override
  void initState() {
    super.initState();

    _config();
  }

  @override
  void dispose() {
    super.dispose();

    _webViewController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        if (_effectiveController == null) {
          return Container();
        }
        return Stack(
          children: <Widget>[
            WebViewWidget(
              controller: _effectiveController!,
            ),
            ValueListenableBuilder(
              valueListenable: _effectiveController!.progress,
              builder: (BuildContext context, double value, Widget? child) {
                return Visibility(
                  visible: value < 1.0,
                  child: LinearProgressIndicator(
                    minHeight: 2.0,
                    value: value,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _config() {
    if (widget.controller == null) {
      _webViewController = YBJFWebViewController();
    }
    _effectiveController?.loadUrl(widget.url);
  }
}

class YBJFWebViewController extends WebViewController {
  final ValueNotifier<String?> title = ValueNotifier(null);
  final ValueNotifier<double> progress = ValueNotifier(0.0);

  YBJFWebViewController() {
    setJavaScriptMode(JavaScriptMode.unrestricted);
    setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int value) {
          progress.value = value / 100;
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) async {
          title.value = await getTitle();
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  loadUrl(String newUrl) {
    if (newUrl.isEmpty) {
      return;
    }
    Uri? uri = Uri.tryParse(newUrl);
    if (uri != null) {
      loadRequest(uri);
    }
  }

  void dispose() {
    title.dispose();
    progress.dispose();
  }
}

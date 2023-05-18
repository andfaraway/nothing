///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020-01-16 19:10
///
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:nothing/constants/constants.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({
    Key? key,
    required this.url,
    this.title,
    this.app,
    this.withCookie = true,
    this.withAppBar = true,
    this.withAction = true,
    this.withBackBtn = false,
    this.withScaffold = true,
    this.keepAlive = false,
    this.safeTop = false,
  })  : assert(url != null),
        assert(keepAlive != null),
        super(key: key);

  final String? url;
  final String? title;
  final WebApp? app;
  final bool withCookie;
  final bool withAppBar;
  final bool withBackBtn;
  final bool withAction;
  final bool withScaffold;
  final bool? keepAlive;
  final bool safeTop;

  static final Tween<Offset> _positionTween = Tween<Offset>(
    begin: const Offset(0, 1),
    end: const Offset(0, 0),
  );

  static Future<void> launch({
    required String url,
    String? title,
    WebApp? app,
    bool withCookie = true,
    bool withAppBar = true,
    bool withAction = true,
    bool withScaffold = true,
    bool keepAlive = false,
  }) {
    return navigatorState.push(
      PageRouteBuilder<void>(
        opaque: false,
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return SlideTransition(
            position: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            ).drive(_positionTween),
            child: child,
          );
        },
        pageBuilder: (_, __, ___) => AppWebView(
          url: url,
          title: title,
          app: app,
          withCookie: withCookie,
          withAppBar: withAppBar,
          withAction: withAction,
          withScaffold: withScaffold,
          keepAlive: keepAlive,
        ),
      ),
    );
  }

  @override
  _AppWebViewState createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> with AutomaticKeepAliveClientMixin {
  final StreamController<double> progressController = StreamController<double>.broadcast();
  Timer? _progressCancelTimer;

  final ValueNotifier<String> title = ValueNotifier<String>('');

  /// 页面是否可以返回
  final ValueNotifier<bool> webCanGoBack = ValueNotifier(false);

  String url = 'about:blank';

  late InAppWebView _webView;
  late InAppWebViewController _webViewController;
  bool useDesktopMode = false;

  String get urlDomain => Uri.parse(url).host;

  @override
  bool get wantKeepAlive => widget.keepAlive ?? false;

  @override
  void initState() {
    super.initState();
    url = (widget.url ?? url).trim();
    title.value = (widget.app?.name ?? widget.title ?? title.value).trim();

    _webView = newWebView;

    print('web app init');
    // Instances.eventBus
    //     .on<CourseScheduleRefreshEvent>()
    //     .listen((CourseScheduleRefreshEvent event) {
    //   if (mounted) {
    //     loadCourseSchedule();
    //   }
    // });
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    progressController.close();
    _progressCancelTimer?.cancel();
    super.dispose();
  }

  InAppWebView get newWebView {
    return InAppWebView(
      key: Key(currentTimeStamp.toString()),
      initialUrlRequest: URLRequest(url: Uri.parse(url)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          applicationNameForUserAgent: 'nothing-webview',
          cacheEnabled: widget.withCookie,
          clearCache: !widget.withCookie,
          horizontalScrollBarEnabled: false,
          javaScriptCanOpenWindowsAutomatically: true,
          supportZoom: true,
          transparentBackground: true,
          useOnDownloadStart: true,
          useShouldOverrideUrlLoading: true,
          preferredContentMode:
              useDesktopMode ? UserPreferredContentMode.DESKTOP : UserPreferredContentMode.RECOMMENDED,
          verticalScrollBarEnabled: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
          builtInZoomControls: true,
          displayZoomControls: false,
          forceDark: currentIsDark ? AndroidForceDark.FORCE_DARK_ON : AndroidForceDark.FORCE_DARK_OFF,
          loadWithOverviewMode: true,
          mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          safeBrowsingEnabled: false,
          supportMultipleWindows: false,
        ),
        ios: IOSInAppWebViewOptions(
          allowsAirPlayForMediaPlayback: true,
          allowsBackForwardNavigationGestures: true,
          allowsLinkPreview: true,
          allowsPictureInPictureMediaPlayback: true,
          isFraudulentWebsiteWarningEnabled: false,
        ),
      ),
      onCreateWindow: (
        InAppWebViewController controller,
        CreateWindowAction createWindowAction,
      ) async {
        if (createWindowAction.request.url != null) {
          await controller.loadUrl(urlRequest: createWindowAction.request);
          return true;
        }
        return false;
      },
      onProgressChanged: (_, int progress) {
        progressController.add(progress / 100);
      },
      onConsoleMessage: (_, ConsoleMessage consoleMessage) {
        LogUtils.d(
          'Console message: '
          '${consoleMessage.messageLevel.toString()}'
          ' - '
          '${consoleMessage.message}',
        );
      },
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
      },
      shouldOverrideUrlLoading: (
        InAppWebViewController controller,
        NavigationAction navigationAction,
      ) async {
        if (checkSchemeLoad(
          controller,
          navigationAction.request.url.toString(),
        )) {
          return NavigationActionPolicy.CANCEL;
        } else {
          return NavigationActionPolicy.ALLOW;
        }
      },
      onUpdateVisitedHistory: (_, Uri? url, bool? androidIsReload) async {
        LogUtils.d('WebView onUpdateVisitedHistory: $url, $androidIsReload');
        // cancelProgress();
      },
      onLoadStop: (InAppWebViewController _, Uri? uri) async {
        print('onLoadStop');
        Future.delayed(const Duration(milliseconds: 200), () async {
          webCanGoBack.value = await _webViewController.canGoBack();
          print('webCanGoBack.value = ${webCanGoBack.value}');
        });
      },
    );
  }

  bool checkSchemeLoad(InAppWebViewController controller, String url) {
    final RegExp protocolRegExp = RegExp(r'(http|https):\/\/([\w.]+\/?)\S*');
    if (!url.startsWith(protocolRegExp) && url.contains('://')) {
      LogUtils.d('Found scheme when load: $url');
      if (Platform.isAndroid) {
        // Future<void>.delayed(1.microseconds, () async {
        //   controller.stopLoading();
        //   LogUtils.d('Try to launch intent...');
        //   final String appName = await ChannelUtils.getSchemeLaunchAppName(url);
        //   if (appName != null) {
        //     if (await isAppJumpConfirm(appName)) {
        //       await _launchURL(url: url);
        //     }
        //   }
        // });
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: widget.withAppBar
      //     ? AppBar(
      //         title: Text(widget.title ?? ''),
      //       )
      //     : null,
      body: SafeArea(
        top: widget.safeTop,
        child: Stack(
          children: [
            _webView,
            if (widget.withBackBtn)
              ValueListenableBuilder(
                builder: (context, bool canGoBack, child) {
                  if (!canGoBack) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(
                        // top: Screens.topSafeHeight,
                        top: 0),
                    child: Container(
                      color: Colors.green,
                      height: 25,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (await _webViewController.canGoBack()) {
                            _webViewController.goBack();
                          }
                        },
                      ),
                    ),
                  );
                },
                valueListenable: webCanGoBack,
              )
          ],
        ),
      ),
    );
  }
}

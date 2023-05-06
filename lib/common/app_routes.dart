//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-16 18:49:44
//
import 'package:nothing/page/favorite_page.dart';
import 'package:nothing/page/feedback_page.dart';
import 'package:nothing/page/file_management.dart';
import 'package:nothing/page/file_preview_page.dart';
import 'package:nothing/page/information_page.dart';
import 'package:nothing/page/live_photo_page.dart';
import 'package:nothing/page/login_page.dart';
import 'package:nothing/page/message_page.dart';
import 'package:nothing/page/music_page.dart';
import 'package:nothing/page/photo_show.dart';
import 'package:nothing/page/release_version.dart';
import 'package:nothing/page/root_page.dart';
import 'package:nothing/page/say_hi.dart';
import 'package:nothing/page/some_things.dart';
import 'package:nothing/page/theme_setting.dart';
import 'package:nothing/page/upload_file.dart';
import 'package:nothing/page/video_play_page.dart';
import 'package:nothing/page/wedding_about.dart';
import 'package:nothing/page/welcome_page.dart';
import 'package:nothing/prefix_header.dart';

typedef ArgumentsWidgetBuilder = Widget Function(dynamic arguments);

class Routes {
  const Routes._();

  static List<RoutePage> routePages = [
    Routes.welcome,
    Routes.root,
    Routes.login,
    Routes.favorite,
    Routes.feedback,
    Routes.message,
    Routes.releaseVersion,
    Routes.sayHi,
    Routes.themeSetting,
    Routes.uploadFile,
    Routes.information,
    Routes.livePhoto,
    Routes.weddingAbout,
    Routes.photoShow,
    Routes.filePreviewPage,
    Routes.fileManagement,
    Routes.someThings,
    Routes.videoPlayPage,
    Routes.musicPage,
  ];

  static Widget pageWithRouteName(String routeName, {Object? arguments}) {
    RoutePage routePage =
        Routes.routePages.firstWhere((element) => element.name == routeName);
    return routePage.page.call(arguments: arguments);
  }

  static final navKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navKey.currentState?.context;

  static final RoutePage root =
      RoutePage(name: '/root', page: ({Object? arguments}) => const RootPage());
  static final RoutePage welcome = RoutePage(
      name: '/welcomeRoute',
      page: ({Object? arguments}) => const WelcomePage());
  static final RoutePage login = RoutePage(
      name: '/loginRoute', page: ({Object? arguments}) => const LoginPage());
  static final RoutePage favorite = RoutePage(
      name: '/favoriteRoute',
      page: ({Object? arguments}) => const FavoritePage());
  static final RoutePage feedback = RoutePage(
      name: '/feedbackRoute',
      page: ({Object? arguments}) => const FeedbackPage());

  static final RoutePage message = RoutePage(
      name: '/messageRoute',
      page: ({Object? arguments}) => const MessagePage());
  static final RoutePage releaseVersion = RoutePage(
      name: '/releaseVersionRoute',
      page: ({Object? arguments}) => const ReleaseVersion());
  static final RoutePage sayHi = RoutePage(
      name: '/sayHiRoute', page: ({Object? arguments}) => const SayHi());
  static final RoutePage themeSetting = RoutePage(
      name: '/themeSettingRoute',
      page: ({Object? arguments}) => const ThemeSettingPage());
  static final RoutePage uploadFile = RoutePage(
      name: '/uploadFileRoute',
      page: ({Object? arguments}) => const UploadFile());

  static final RoutePage information = RoutePage(
      name: '/informationRoute',
      page: ({Object? arguments}) => const InformationPage());
  static final RoutePage livePhoto = RoutePage(
      name: '/livePhotoRoute',
      page: ({Object? arguments}) => const LivePhotoPage());
  static final RoutePage weddingAbout = RoutePage(
      name: '/weddingAboutRoute',
      page: ({Object? arguments}) => const WeddingAbout());
  static final RoutePage photoShow = RoutePage(
      name: '/photoShowRoute',
      page: ({Object? arguments}) => PhotoShow(
            arguments: arguments,
          ));
  static final RoutePage filePreviewPage = RoutePage(
      name: '/filePreviewPageRoute',
      page: ({Object? arguments}) => FilePreviewPage(
            arguments: arguments,
          ));
  static final RoutePage fileManagement = RoutePage(
      name: '/fileManagementRoute',
      page: ({Object? arguments}) => FileManagement(
            arguments: arguments,
          ));
  static final RoutePage someThings = RoutePage(
      name: '/someThingsRoute',
      page: ({Object? arguments}) => const SomeThings());

  static final RoutePage videoPlayPage = RoutePage(
      name: '/videoPlayPageRoute',
      page: ({Object? arguments}) => const VideoPlayPage());
  static final RoutePage musicPage = RoutePage(
      name: '/musicPageRoute',
      page: ({Object? arguments}) => const MusicPage());

  static Future<dynamic> pushPage(BuildContext context, Widget page) async {
    dynamic value =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
    return value;
  }

  static Future<dynamic> pushNamePage(BuildContext context, String routeName,
      {Object? arguments}) async {
    dynamic value =
        await Navigator.pushNamed(context, routeName, arguments: arguments);
    return value;
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
      BuildContext context, String newRouteName,
      {Object? arguments}) async {
    dynamic value = await Navigator.pushNamedAndRemoveUntil(
        context, newRouteName, (route) => false,
        arguments: arguments);
    return value;
  }

  static Future<dynamic> pop(
      {BuildContext? buildContext, dynamic arguments}) async {
    buildContext ??= context;
    if (buildContext == null) return Future.value(null);
    Navigator.maybePop(buildContext, arguments);
  }

  static Future<void> popUntil(BuildContext context, String routeName) async {
    Navigator.popUntil(context, (route) {
      if (route.settings.name == routeName) {
        return true;
      }
      return false;
    });
  }
}

/// 处理服务器目标页面
class ServerTargetModel {
  ServerTargetModel({this.type = 0, this.url, this.page, this.routeName});

  /// [type] 类型0.页面  1.webView
  int type;

  /// [url] webView url
  String? url;

  /// [page] 路由页面
  Widget? page;

  ///  [routeName]路由名称
  String? routeName;

  /// 安全头部
  bool safeTop = false;

  static ServerTargetModel fromString(BuildContext context, String targetStr) {
    ServerTargetModel model = ServerTargetModel();
    if ('web:'.matchAsPrefix(targetStr) != null) {
      model.type = 1;
      String content = targetStr.split('web:').last;
      if (targetStr.contains("&")) {
        if (content.split('&').first.toString() == '1') {
          model.safeTop = true;
        }
        model.url = content.split("&").last;
      } else {
        model.url = content;
      }
    } else {
      List<String> splitList = targetStr.split(',');
      model.type = 0;
      model.routeName = splitList.first;
      print('targetStr = $splitList');

      if (splitList.isEmpty) {
        model.page = Routes.routePages
            .firstWhere((element) => element.name == splitList.first)
            .page(arguments: splitList.length > 1 ? splitList.last : null);
      } else {
        model.page = null;
      }
    }
    return model;
  }
}

typedef RoutePageCallback = Widget Function({Object? arguments});

class RoutePage {
  final String name;
  final RoutePageCallback page;
  Middleware? middleware;

  RoutePage({
    required this.name,
    required this.page,
    this.middleware,
  });
}

abstract class Middleware {
  RouteSettings? redirect(String? route) {
    return RouteSettings(name: route);
  }
}

class LoginMiddleware extends Middleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Handler.isUserLogin) {
      return RouteSettings(name: Routes.login.name);
    }
    return super.redirect(route);
  }
}

RouteFactory? onGenerateRoute = (RouteSettings settings) {
  RouteSettings? routeSettings = settings;
  int index = Routes.routePages
      .indexWhere((element) => element.name == routeSettings?.name);
  if (index >= 0) {
    RoutePage routePage = Routes.routePages[index];
    if (routePage.middleware != null) {
      RouteSettings? redirectRouteSettings =
          routePage.middleware?.redirect(routeSettings.name);
      int redirectIndex = Routes.routePages
          .indexWhere((element) => element.name == redirectRouteSettings?.name);
      if (redirectIndex >= 0) {
        routeSettings = redirectRouteSettings;
        routePage = Routes.routePages[redirectIndex];
      }
    }
    return MaterialPageRoute(
      builder: (BuildContext context) => routePage.page(
        arguments: routeSettings?.arguments,
      ),
      settings: routeSettings,
    );
  }
  return null;
};

class AppNavigatorObserver extends RouteObserver {
  static final List<Route> routeList = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    routeList.add(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    routeList.remove(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute != null) {
      int index = routeList.indexWhere((element) => element == oldRoute);
      if (index >= 0) {
        routeList.replaceRange(index, index + 1, [newRoute]);
      }
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    routeList.remove(route);
  }
}
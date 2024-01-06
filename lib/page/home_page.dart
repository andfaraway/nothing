//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-04 18:13:56

import 'package:nothing/page/information_page.dart';
import 'package:nothing/widgets/app_webview.dart';

import '../common/prefix_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Widget? homeWidget;

  @override
  void initState() {
    super.initState();

    // 初始界面
    String? homePage = context.read<LaunchProvider>().launchInfo?.homePage;
    if (homePage != null) {
      ServerTargetModel targetModel =
          ServerTargetModel.fromString(context, homePage);
      if (targetModel.type == 0) {
        homeWidget = targetModel.page;
      } else {
        homeWidget = AppWebView(
          url: targetModel.url,
          title: 'nothing',
        );
      }
    }
    homeWidget ??= const InformationPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: homeWidget!,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

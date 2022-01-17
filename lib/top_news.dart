//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-08 18:11:32

import 'package:nothing/widgets/webview/in_app_webview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/constants.dart';

typedef RequestCallback = Future Function();

class TopNewsPage extends StatefulWidget {
  const TopNewsPage({
    Key? key,
    this.title,
    this.backgroundColor,
    this.requestCallback,
  }) : super(key: key);

  final String? title;
  final Color? backgroundColor;
  final RequestCallback? requestCallback;

  @override
  _TopNewsPageState createState() => _TopNewsPageState();
}

class _TopNewsPageState extends State<TopNewsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _controller = RefreshController(initialRefresh: true);
  final double marginWidth = 30;
  List<TopNewsModel> newsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: Screens.navigationBarHeight,
              alignment: Alignment.center,
              child: Text(
                widget.title ?? '',
                style: TextStyle(
                    color: widget.backgroundColor?.getAdaptiveColor,
                    fontSize: 28),
              ),
            ),
            Expanded(
              child: SmartRefresher(
                onRefresh: () async {
                  var list = await widget.requestCallback?.call();
                  newsList.clear();
                  list?.forEach((element) =>
                      newsList.add(TopNewsModel().fromJson(element)));
                  if (mounted) {
                    setState(() {});
                  }
                  _controller.refreshCompleted();
                },
                controller: _controller,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        launch(newsList[index].url ?? '');return;
                        AppWebView.launch(
                            url: newsList[index].url ?? '',title: newsList[index].title
                        );
                      },
                      child: ListTile(
                        title: Text(newsList[index].title ?? '',style: TextStyle(color: widget.backgroundColor?.getAdaptiveColor),),
                      ),
                    );
                  },
                  itemCount: newsList.length,
                  shrinkWrap: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopNewsModel {
  final String? id;
  final String? ctime;
  final String? title;
  final String? description;
  final String? picUrl;
  final String? url;
  final String? source;

  TopNewsModel(
      {this.id,
      this.ctime,
      this.title,
      this.description,
      this.picUrl,
      this.url,
      this.source});

  TopNewsModel fromJson(Map map) {
    return TopNewsModel(
        id: map['id'],
        ctime: map['ctime'],
        title: map['title'],
        description: map['description'],
        picUrl: map['picUrl'],
        url: map['url'],
        source: map['source']);
  }
}

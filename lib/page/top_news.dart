//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-08 18:11:32

import 'package:nothing/common/prefix_header.dart';

typedef RequestCallback = Future Function();

class TopNewsPage extends StatefulWidget {
  const TopNewsPage({
    Key? key,
    this.title,
    this.backgroundColor,
  }) : super(key: key);

  final String? title;
  final Color? backgroundColor;

  @override
  State<TopNewsPage> createState() => _TopNewsPageState();
}

class _TopNewsPageState extends State<TopNewsPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final AppRefreshController _controller = AppRefreshController(autoRefresh: true);
  final double marginWidth = 30;
  List<TopNewsModel> newsList = [];

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: AppRefresher(
          onRefresh: _loadData,
          controller: _controller,
          child: ListView.separated(
            padding: AppPadding.main,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  launchUrlString(newsList[index].url ?? '');
                },
                child: Container(
                    decoration:
                        BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(AppSize.radiusMedium)),
                    child: NormalCell(title: newsList[index].title, showDivider: false, showSuffixIcon: false)),
              );
            },
            itemCount: newsList.length,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int index) {
              return 10.hSizedBox;
            },
          ),
        ),
      ),
    );
  }

  _loadData() async {
    List list = (await API.informationApi(InformationType.topNews))['newslist'];
    newsList = list.map((e) => TopNewsModel.fromJson(e)).toList();
    _controller.completed(success: true);
    setState(() {});
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

  TopNewsModel({this.id, this.ctime, this.title, this.description, this.picUrl, this.url, this.source});

  static TopNewsModel fromJson(Map map) {
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

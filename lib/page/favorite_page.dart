//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-12 18:04:14
//

import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/favorite_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late final AppRefreshController _refreshController = AppRefreshController(autoRefresh: true);

  List<FavoriteModel> dataList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    List? list = await API.getFavorite();
    _refreshController.completed(success: true);
    if (list == null) {
      showToast(S.current.request_failed);
      return;
    }

    dataList.clear();
    for (Map<String, dynamic> map in list) {
      FavoriteModel model = FavoriteModel.fromJson(map);
      dataList.add(model);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(S.current.favorite),
      ),
      body: AppRefresher(
        onRefresh: () {
          loadData();
        },
        controller: _refreshController,
        child: dataList.isEmpty
            ? const Center(
                child: Text('nothing'),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                child: Column(children: dataList.map((model) => messageWidget(model)).toList()),
              ),
      ),
    );
  }

  Widget messageWidget(FavoriteModel model) {
    return Padding(
      padding: EdgeInsets.all(17.w),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.xSource ?? 'nothing',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    model.date?.dataFormat() ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColor.placeholderColor),
                  )
                ],
              ),
              15.hSizedBox,
              Text(
                model.content ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}

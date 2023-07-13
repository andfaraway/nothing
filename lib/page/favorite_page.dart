//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-12 18:04:14
//

import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/favorite_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late final AppRefreshController _refreshController = AppRefreshController(autoRefresh: true);

  List<FavoriteModel> dataList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    AppResponse response = await API.getFavorite();

    if (response.isSuccess) {
      dataList.clear();
      for (Map<String, dynamic> map in response.dataList) {
        FavoriteModel model = FavoriteModel.fromJson(map);
        dataList.add(model);
      }
      setState(() {});
      _refreshController.completed(success: true);
    } else {
      showToast(S.current.request_failed);
    }
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
                    model.date?.dateFormat() ?? '',
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

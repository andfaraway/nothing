//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-12 18:04:14
//

import 'package:nothing/public.dart';
import 'package:nothing/model/favorite_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late final RefreshController _refreshController;

  List<FavoriteModel> dataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = RefreshController();
    loadData();
  }

  Future<void> loadData() async {
    List? list = await API.getFavorite();
    if (list == null) {
      showToast(S.current.request_failed);
      _refreshController.refreshCompleted();
      return;
    }

    dataList.clear();
    for (Map<String, dynamic> map in list) {
      FavoriteModel model = FavoriteModel.fromJson(map);
      dataList.add(model);
    }
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.background,
      appBar: AppBar(
        title: Text(S.current.favorite),
      ),
      body: SmartRefresher(
        onRefresh: () {
          loadData();
        },
        controller: _refreshController,
        child: dataList.isEmpty
            ? const Center(
                child: Text('nothing'),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
                child: Column(
                    children:
                        dataList.map((model) => messageWidget(model)).toList()),
              ),
      ),
    );
  }

  Widget messageWidget(FavoriteModel model) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.w),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 45.w, right: 45.w, top: 36.h, bottom: 36.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.xSource ?? 'nothing',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model.date?.dataFormat() ?? '',
                    style: TextStyle(
                      color: const Color(0xff888888),
                      fontSize: 28.sp,
                    ),
                  )
                ],
              ),
              30.hSizedBox,
              Text(
                model.content ?? '',
                style: TextStyle(
                  color: const Color(0xff888888),
                  fontSize: 28.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

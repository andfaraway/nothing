import 'dart:math';

import 'package:nothing/common/prefix_header.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<double> _rotate = ValueNotifier(0);

  List<Widget> _cellList = [];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // 关闭收缩
      if (_scrollController.offset > 0) {
        _scrollController.jumpTo(0);
      }
      _rotate.value = _scrollController.offset / 100;
    });

    _cellList = [
      _titleCell(
          icon: AppImage.asset(R.tabActivity),
          title: '主题',
          onTap: () => AppRoute.pushNamePage(context, AppRoute.themeSetting.name)),
      _titleCell(
          icon: AppImage.asset(R.imagesSettings),
          title: '设置',
          onTap: () => AppRoute.pushNamePage(context, AppRoute.setting.name)),
      _titleCell(
          icon: AppImage.asset(R.imagesLogOut),
          title: '退出登录',
          onTap: () {
            showConfirmToast(context: context, title: '退出登录', onConfirm: Constants.logout);
          }),
    ];
  }

  @override
  void dispose() {
    _rotate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          leading: const SizedBox.shrink(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight: 80,
          actions: [
            ValueListenableBuilder(
                valueListenable: _rotate,
                builder: (context, value, child) {
                  return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Transform.rotate(
                            angle: _rotate.value * pi,
                            child: AppImage.asset(R.imagesRing1, width: 25, height: 25, fit: BoxFit.cover)),
                      ));
                })
          ],
          pinned: true,
          stretch: true,
          // toolbarHeight:200,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            stretchModes: const [
              StretchMode.fadeTitle,
              // StretchMode.blurBackground,
              StretchMode.zoomBackground
            ],
            background: AppImage.network('http://1.14.252.115/src/handsomeman.jpeg', fit: BoxFit.cover),
          ),
        ),
        SliverPadding(
          padding: AppPadding.main,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return _cellList[index];
              },
              childCount: _cellList.length,
            ),
          ),
        )
      ],
    );
  }

  Widget _titleCell({required Widget icon, required String title, required VoidCallback? onTap}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.white),
              height: 44,
              child: Row(
                children: [
                  AppPadding.horizontal.wSizedBox,
                  icon,
                  AppPadding.horizontal.wSizedBox,
                  Text(
                    title,
                    style: AppTextStyle.titleMedium,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

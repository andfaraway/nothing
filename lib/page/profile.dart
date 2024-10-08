import 'dart:math';

import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/games/gomoku/gomoku.dart';
import 'package:flutter_tetris/flutter_tetris.dart';
import 'flutter/catalog_page.dart';

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
  }

  @override
  void dispose() {
    _rotate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _cellList = [
      _titleCell(
          icon: AppImage.asset(R.tabActivity),
          title: '主题',
          onTap: () => AppRoute.pushNamePage(context, AppRoute.themeSetting.name)),
      _titleCell(
          icon: const Icon(
            Icons.videogame_asset_rounded,
            size: 20,
          ),
          title: 'Tetris',
          onTap: () {
            AppRoute.pushPage(context, TetrisWidget());
          }),
      _titleCell(
          icon: const FlutterLogo(
            size: 20,
          ),
          title: 'Flutter',
          onTap: () {
            AppRoute.pushPage(context, const CatalogPage());
          }),
      _titleCell(
          icon: const Icon(
            Icons.ac_unit_sharp,
            size: 20,
          ),
          title: '五子棋',
          onTap: () {
            AppRoute.pushPage(context, const Gomoku());
          }),
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
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            stretchModes: const [
              StretchMode.fadeTitle,
              // StretchMode.blurBackground,
              StretchMode.zoomBackground
            ],
            background: AppImage.asset(R.imagesHandsomeman, fit: BoxFit.cover),
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

  Widget _titleCell({Widget? icon, required String title, required VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.vertical),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClayContainer(
          color: const Color(0xFFF2F2F2),
          curveType: CurveType.none,
          borderRadius: 75,
          customBorderRadius: BorderRadius.only(
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(18.r),
          ),
          depth: 10,
          // spread: 12,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal.w, vertical: AppPadding.horizontal.w),
            child: Center(
              child: Row(
                children: [
                  if (icon != null) icon,
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

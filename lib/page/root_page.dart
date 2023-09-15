import 'dart:ui';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing/widgets/app_drawer.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../common/prefix_header.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  List<BarItem> _rootBars = [];

  late final TabController _tabController;

  final GlobalKey _tabBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadData();

    Handler.getUserInfo();

    _tabController = TabController(
      length: _rootBars.length,
      vsync: this,
      animationDuration: Duration.zero,
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderBox = _tabBarKey.currentContext!.findRenderObject() as RenderBox;
      AppSize.tabBarHeight = renderBox.size.height;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Stack(
      children: [
        Consumer2<ThemesProvider, HomeProvider>(builder: (context, themesProvider, homeProvider, child) {
          _tabController.index = homeProvider.pageIndex;
          return Scaffold(
            drawer: const AppDrawer(),
            drawerEnableOpenDragGesture: true,
            onEndDrawerChanged: (open) {
              print('open=$open');
            },
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: _rootBars.map((e) => e.page).toList(),
            ),
            floatingActionButton: _floatingActionButton(),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: _salomonBottomBar(onTap: (index) {
              setState(() {
                homeProvider.pageIndex = index;
              });
            }),
          );
        }),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: Tools.confettiController,
            numberOfParticles: 50,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        )
      ],
    );
  }

  Widget _floatingActionButton() {
    return InkWell(
      onTap: () {
        // showMaterialModalBottomSheet(
        //     context: context,
        //     builder: (_) {
        //       return const ExceptionTestPage();
        //     });
        // return;

        AppToast.show(
          context: context,
          builder: (context) {
            return IgnorePointer(
              child: Center(
                child: Lottie.asset(
                  R.lottieAnimationLove,
                  width: double.infinity,
                  height: double.infinity,
                  repeat: false,
                  onLoaded: (LottieComposition s) {
                    Future.delayed(s.duration, () => AppToast.remove());
                  },
                ),
              ),
            );
          },
        );
      },
      child: Lottie.asset(
        R.lottieAnimationChicken,
        width: 88.r,
        height: 88.r,
        repeat: true,
        onLoaded: (LottieComposition s) {
          // Future.delayed(s.duration, () => AppToast.remove());
        },
      ),
      // child: AppImage.asset(R.iconsGift, width: 44.r, height: 44.r),
    );
  }

  Widget _salomonBottomBar({required Function(int) onTap}) {
    return RepaintBoundary(
      key: _tabBarKey,
      child: ClipRect(
        child: BackdropFilter(
          //毛玻璃
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SalomonBottomBar(
            backgroundColor: AppColor.white.withOpacity(.7),
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            currentIndex: _tabController.index,
            onTap: onTap,
            items: _rootBars
                .map(
                  (item) => SalomonBottomBarItem(
                    icon: item.icon,
                    title: Text(item.label),
                    selectedColor: item.selectedColor,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigationBar({required Function(int) onTap}) {
    return AnimatedBottomNavigationBar.builder(
      // elevation: 0.5,
      // gapWidth: 44.0.w,
      shadow: BoxShadow(
        offset: const Offset(0.0, 1.0),
        blurRadius: 1.0,
        color: Colors.black.withOpacity(0.1),
      ),
      backgroundColor: AppColor.tabColor,
      activeIndex: _tabController.index,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      splashSpeedInMilliseconds: 0,
      leftCornerRadius: 10,
      rightCornerRadius: 10,
      onTap: onTap,
      itemCount: _rootBars.length,
      tabBuilder: (int index, bool isActive) {
        BarItem item = _rootBars[index];
        return Container(
            width: item.size,
            height: item.size,
            margin: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: isActive ? item.activeIcon : item.icon);
      }, //other params
    );
  }

  void _loadData() {
    _rootBars = [
      BarItem(
        icon: const Icon(Icons.home),
        activeIcon: const Icon(Icons.home),
        label: '资讯',
        page: AppRoute.home.page.call(),
        selectedColor: Colors.purple,
      ),
      BarItem(
        icon: const Icon(Icons.mail_outline),
        activeIcon: AppImage.asset(R.tabMail, color: AppColor.errorColor, fit: BoxFit.contain),
        label: '信息',
        page: AppRoute.message.page.call(),
        selectedColor: Colors.pinkAccent,
      ),
      // BarItem(
      //   icon: const Icon(Icons.data_usage),
      //   activeIcon: const Icon(Icons.data_usage),
      //   label: '色彩板',
      //   page: AppRoute.funnyColors.page.call(),
      //   selectedColor: Colors.orange,
      // ),
      BarItem(
        icon: const Icon(Icons.book),
        activeIcon: const Icon(Icons.book),
        label: '诗歌',
        page: AppRoute.poetry.page.call(),
        selectedColor: AppRoute.poetry.pageColor,
      ),
      BarItem(
          icon: const Icon(Icons.person),
          activeIcon: const Icon(Icons.person),
          label: '我的',
          page: AppRoute.profile.page.call(),
          selectedColor: Colors.teal),
    ];
  }
}

class BarItem {
  const BarItem(
      {required this.icon,
      required this.activeIcon,
      required this.label,
      required this.page,
      required this.selectedColor,
      this.size = 24});

  final Widget icon;
  final double size;
  final Widget activeIcon;
  final String label;
  final Widget page;
  final Color selectedColor;
}

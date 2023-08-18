import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:confetti/confetti.dart';
import 'package:nothing/widgets/drawer.dart';

import '../common/prefix_header.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with SingleTickerProviderStateMixin {
  List<BarItem> _rootBars = [];

  late final TabController _tabController;

  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 10));

  @override
  void initState() {
    super.initState();
    _loadData();

    _tabController = TabController(
      length: _rootBars.length,
      vsync: this,
      animationDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _confettiController.dispose();
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
            drawer: const CustomDrawer(),
            drawerEnableOpenDragGesture: false,
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: _rootBars.map((e) => e.page).toList(),
            ),
            floatingActionButton: InkWell(
              onTap: () {
                if (_confettiController.state == ConfettiControllerState.playing) {
                  _confettiController.stop();
                } else {
                  _confettiController.play();
                }
              },
              child: AppImage.asset(R.iconsGift, width: 44.r, height: 44.r),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar.builder(
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
              onTap: (index) => homeProvider.pageIndex = index,
              itemCount: _rootBars.length,
              tabBuilder: (int index, bool isActive) {
                BarItem item = _rootBars[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isActive ? item.activeIcon : item.icon,
                    ],
                  ),
                );
              }, //other params
            ),
          );
        }),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            numberOfParticles: 50,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          ),
        )
      ],
    );
  }

  void _loadData() {
    double iconSize = 24.w;
    _rootBars = [
      BarItem(
          icon: AppImage.asset(R.tabRss, color: AppColor.secondlyColor, width: iconSize, height: iconSize),
          activeIcon: AppImage.asset(R.tabRss, color: AppColor.errorColor, width: iconSize, height: iconSize),
          label: '资讯',
          page: AppRoute.home.page.call()),
      BarItem(
          icon: AppImage.asset(R.tabMail, color: AppColor.secondlyColor, width: iconSize, height: iconSize),
          activeIcon: AppImage.asset(R.tabMail, color: AppColor.errorColor, width: iconSize, height: iconSize),
          label: '信息',
          page: AppRoute.message.page.call()),
      // BarItem(
      //     icon: AppImage.asset(R.tabAperture, color: AppColor.secondlyColor,width: iconSize,height: iconSize),
      //     activeIcon: AppImage.asset(R.tabAperture, color: AppColor.errorColor,width: iconSize,height: iconSize),
      //     label: '图片',
      //     page: AppRoute.photoShow.page.call()),
      BarItem(
          icon: AppImage.asset(R.tabColor, color: AppColor.secondlyColor, width: iconSize, height: iconSize),
          activeIcon: AppImage.asset(R.tabColor, color: AppColor.errorColor, width: iconSize, height: iconSize),
          label: '色彩板',
          page: AppRoute.funnyColors.page.call()),
      BarItem(
          icon: AppImage.asset(R.tabUser, color: AppColor.secondlyColor, width: iconSize, height: iconSize),
          activeIcon: AppImage.asset(R.tabUser, color: AppColor.errorColor, width: iconSize, height: iconSize),
          label: '我的',
          page: AppRoute.profile.page.call()),
    ];
    Handler.getUserInfo();
  }
}

class BarItem {
  const BarItem({required this.icon, required this.activeIcon, required this.label, required this.page});

  final Widget icon;
  final Widget activeIcon;
  final String label;
  final Widget page;
}

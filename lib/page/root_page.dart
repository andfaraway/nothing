import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemesProvider, HomeProvider>(builder: (context, themesProvider, homeProvider, child) {
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
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            child: AppImage.asset(R.tabSend, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          // elevation: 0.5,
          // gapWidth: 44.0.w,
          shadow: BoxShadow(
            offset: const Offset(0.0, 1.0),
            blurRadius: 1.0,
            color: Colors.black.withOpacity(0.1),
          ),
          backgroundColor: themesProvider.currentThemeGroup.themeColor,
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
    });
  }

  _loadData() {
    _rootBars = [
      BarItem(
          icon: AppImage.asset(R.tabRss, color: AppColor.placeholderColor),
          activeIcon: AppImage.asset(R.tabRss, color: AppColor.errorColor),
          label: '信息',
          page: AppRoute.home.page.call()),
      BarItem(
          icon: AppImage.asset(R.tabMail, color: AppColor.placeholderColor),
          activeIcon: AppImage.asset(R.tabMail, color: AppColor.errorColor),
          label: '信息',
          page: AppRoute.message.page.call()),
      BarItem(
          icon: AppImage.asset(R.tabAperture, color: AppColor.placeholderColor),
          activeIcon: AppImage.asset(R.tabAperture, color: AppColor.errorColor),
          label: '图片',
          page: AppRoute.photoShow.page.call()),
      BarItem(
          icon: AppImage.asset(R.tabUser, color: AppColor.placeholderColor),
          activeIcon: AppImage.asset(R.tabUser, color: AppColor.errorColor),
          label: '我的',
          page: AppRoute.profile.page.call()),
    ];
  }
}

class BarItem {
  const BarItem({required this.icon, required this.activeIcon, required this.label, required this.page});

  final Widget icon;
  final Widget activeIcon;
  final String label;
  final Widget page;
}

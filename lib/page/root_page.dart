import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:nothing/widgets/drawer.dart';

import '../common/prefix_header.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  List<BarItem> rootBars = [];

  late final PageController _pageController;
  final ValueNotifier<int> _bottomNavIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _bottomNavIndex.value);
    _bottomNavIndex.addListener(() {
      _pageController.jumpToPage(_bottomNavIndex.value);
    });

    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemesProvider provider = Provider.of<ThemesProvider>(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      drawerEnableOpenDragGesture: false,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: rootBars.map((e) => e.page).toList(),
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
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _bottomNavIndex,
          builder: (context, index, child) {
            return AnimatedBottomNavigationBar.builder(
              // elevation: 0.5,
              // gapWidth: 44.0.w,
              shadow: BoxShadow(
                offset: const Offset(0.0, 1.0),
                blurRadius: 1.0,
                color: Colors.black.withOpacity(0.1),
              ),
              backgroundColor: provider.currentThemeGroup.themeColor,
              activeIndex: index,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.defaultEdge,
              splashSpeedInMilliseconds: 0,
              leftCornerRadius: 10,
              rightCornerRadius: 10,
              onTap: (index) => setState(() => _bottomNavIndex.value = index),
              itemCount: rootBars.length,
              tabBuilder: (int index, bool isActive) {
                BarItem item = rootBars[index];
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
            );
          }),
    );
  }

  _loadData() {
    rootBars = [
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
  const BarItem(
      {required this.icon,
      required this.activeIcon,
      required this.label,
      required this.page});

  final Widget icon;
  final Widget activeIcon;
  final String label;
  final Widget page;
}

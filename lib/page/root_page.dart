import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../prefix_header.dart';

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
    return Scaffold(
      // extendBody: true,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: rootBars.map((e) => e.page).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: _bottomNavIndex,
          builder: (context, index, child) {
            return AnimatedBottomNavigationBar.builder(
              activeIndex: index,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.defaultEdge,
              splashSpeedInMilliseconds: 0,
              leftCornerRadius: 0,
              rightCornerRadius: 0,
              onTap: (index) => setState(() => _bottomNavIndex.value = index),
              itemCount: rootBars.length,
              tabBuilder: (int index, bool isActive) {
                BarItem item = rootBars[index];
                return Column(
                  children: [
                    isActive ? item.activeIcon : item.icon,
                    Text(
                      item.label,
                      style: TextStyle(
                          color: isActive ? errorColor : placeholderColor),
                    )
                  ],
                );
              }, //other params
            );
          }),
    );
  }

  _loadData() {
    rootBars = [
      BarItem(
          icon: const Icon(Icons.favorite),
          activeIcon: Icon(Icons.favorite, color: errorColor),
          label: '收藏',
          page: Routes.favorite.page.call()),
      BarItem(
          icon: const Icon(Icons.message),
          activeIcon: Icon(Icons.message, color: errorColor),
          label: '信息',
          page: Routes.message.page.call()),
      BarItem(
          icon: const Icon(Icons.chat),
          activeIcon: Icon(Icons.chat, color: errorColor),
          label: '实况',
          page: Routes.livePhoto.page.call()),
      BarItem(
          icon: const Icon(Icons.receipt_long),
          activeIcon: Icon(Icons.receipt_long, color: errorColor),
          label: '我的',
          page: Routes.feedback.page.call()),
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

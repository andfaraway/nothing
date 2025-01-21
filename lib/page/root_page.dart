import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:nothing/widgets/app_drawer.dart';
import 'package:nothing/widgets/drag_move_box.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../common/prefix_header.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey _tabBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'sleep') {
        final provider = context.read<HomeProvider>();
        provider.pageIndex = 1;
        provider.actionType = ActionType.playSleep;
        AppMessage.send(ActionEvent(ActionType.playSleep));
      }
    });
    quickActions
        .setShortcutItems(<ShortcutItem>[const ShortcutItem(type: 'sleep', localizedTitle: 'sleep', icon: 'music')]);

    _tabController = TabController(
      length: context.read<HomeProvider>().rootBars.length,
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
    return Stack(
      children: [
        Consumer2<ThemesProvider, HomeProvider>(builder: (context, themesProvider, homeProvider, child) {
          _tabController.index = homeProvider.pageIndex;
          print('index=${homeProvider.showFunny}');
          return Scaffold(
            drawer: const AppDrawer(),
            drawerEnableOpenDragGesture: true,
            onEndDrawerChanged: (open) {},
            extendBody: false,
            resizeToAvoidBottomInset: false,
            body: DragHoverBothSidesWidget(
              dragSize: Size(88.r, 88.r),
              dragWidget: _floatingActionButton(visible: homeProvider.showFunny),
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: homeProvider.rootBars.map((e) => e.page).toList(),
              ),
            ),
            bottomNavigationBar: _salomonBottomBar(homeProvider, onTap: (index) {
              homeProvider.pageIndex = index;
              homeProvider.showFunny = index == 0;
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

  Widget _floatingActionButton({required bool visible}) {
    return Visibility(
      visible: visible,
      child: Builder(
          key: UniqueKey(),
          builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Lottie.asset(
                R.lottieAnimationWalk,
                width: 88.r,
                height: 88.r,
                repeat: true,
              ),
            );
          }),
    );
  }

  Widget _salomonBottomBar(HomeProvider logic, {required Function(int) onTap}) {
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
            items: logic.rootBars
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

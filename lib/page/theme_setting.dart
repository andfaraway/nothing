//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 17:27:25
//

import 'package:flutter_colors_border/flutter_colors_border.dart';
import 'package:nothing/constants/constants.dart';

class ThemeSettingPage extends StatelessWidget {
  const ThemeSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.theme,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<ThemesProvider>(
            builder: (context, provider, child) {
              return Container(
                height: 200,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        provider.currentThemeGroup.name,
                        style: TextStyle(
                            color: Constants.isDark
                                ? provider.currentThemeGroup.darkThemeColor
                                : provider.currentThemeGroup.lightThemeColor,
                            fontSize: 25),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Transform(
                            transform: Matrix4.identity()..scale(1.2),
                            alignment: Alignment.center,
                            child: Consumer<ThemesProvider>(
                                builder: (context, provider, child) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Switch(
                                  value: provider.filterColor !=
                                      Colors.transparent,
                                  activeColor: Colors.black,
                                  inactiveThumbColor: Constants.isDark
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.white,
                                  onChanged: (isDark) {
                                    provider.filterColor == Colors.transparent
                                        ? provider.filterColor = Colors.white
                                        : provider.filterColor =
                                            Colors.transparent;
                                  },
                                ),
                              );
                            }),
                          ),
                          const Text('置灰')
                        ],
                      ),
                    ),
                    child ?? const SizedBox.shrink()
                  ],
                ),
              );
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  Transform(
                    transform: Matrix4.identity()..scale(1.2),
                    alignment: Alignment.center,
                    child: Consumer<ThemesProvider>(
                        builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Switch(
                          value: Constants.isDark,
                          activeColor: Colors.black,
                          inactiveThumbColor: Constants.isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                          onChanged: (isDark) {
                            provider.dark = isDark;
                            Constants.isDark = isDark;
                          },
                        ),
                      );
                    }),
                  ),
                  const Text('深色')
                ],
              ),
            ),
          ),
          GridView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _ThemeContainer(
                themeGroup: supportThemeGroups[index],
                themeIndex: index,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              childAspectRatio: Screens.width / 3 / 80,
            ),
            itemCount: supportThemeGroups.length,
            shrinkWrap: true,
          ),
          const _InformationContainer()
        ],
      ),
    );
  }
}

class _ThemeContainer extends StatelessWidget {
  const _ThemeContainer(
      {Key? key, required this.themeGroup, required this.themeIndex})
      : super(key: key);

  final ThemeGroup themeGroup;
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    double w = (Screens.width - 16 * 3) / 3;
    final Size size = Size(w, 80);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ThemesProvider>(
        builder: (context, provider, child) => GestureDetector(
          onTap: () {
            print('1111');
            provider.currentThemeGroup = themeGroup;
            HiveFieldUtils.setColorTheme(themeIndex);
          },
          child: FlutterColorsBorder(
            available: themeGroup == provider.currentThemeGroup,
            size: size,
            boardRadius: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                color: Constants.isDark
                    ? themeGroup.darkThemeColor
                    : themeGroup.lightThemeColor,
                alignment: Alignment.center,
                child: Text(themeGroup.name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InformationContainer extends StatelessWidget {
  const _InformationContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemesProvider provider = context.read<ThemesProvider>();
    ValueNotifier<Color> colorNotifier =
        ValueNotifier(provider.informationBgColor);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text("Information Background"),
          10.hSizedBox,
          ValueListenableBuilder(
              valueListenable: colorNotifier,
              builder: (context, Color color, child) {
                print('rebuild');
                return ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Container(
                    height: 90.h,
                    color: color,
                    child: TextField(
                      controller: TextEditingController(
                          text: "#" + color.value.toRadixString(16)),
                      decoration: const InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        isDense: true,
                      ),
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        print('textChange:$value');
                        if (value.length == 9 && value.contains("#")) {
                          int c =
                              int.parse(value.replaceAll("#", ""), radix: 16);
                          colorNotifier.value = Color(c);
                        }
                      },
                    ),
                    alignment: Alignment.center,
                  ),
                );
              }),
          10.hSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              resetButton(S.current.random, () {
                colorNotifier.value = getRandomColor();
              }),
              resetButton(S.current.reset, () {
                colorNotifier.value =
                    context.read<ThemesProvider>().informationBgColor;
              }),
              resetButton(S.current.save, () {
                context.read<ThemesProvider>().informationBgColor =
                    colorNotifier.value;
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget resetButton(String title, VoidCallback? onPressed) {
    return MaterialButton(
      height: 55.h,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
      color: Colors.lightGreen,
    );
  }
}

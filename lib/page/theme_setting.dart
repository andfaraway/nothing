//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 17:27:25
//

import 'package:flutter_colors_border/flutter_colors_border.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/page/fonts_setting.dart';

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
      body: Padding(
        padding: AppPadding.main,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Consumer<ThemesProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    Container(
                      height: 150.h,
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
                                  fontSize: AppTextStyle.displayLarge.fontSize),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                Transform(
                                  transform: Matrix4.identity()..scale(1.2),
                                  alignment: Alignment.center,
                                  child: Consumer<ThemesProvider>(builder: (context, provider, child) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Switch(
                                        value: provider.filterColor != Colors.transparent,
                                        activeColor: Colors.black,
                                        inactiveThumbColor:
                                            Constants.isDark ? Colors.white.withOpacity(0.5) : Colors.white,
                                        onChanged: (isDark) {
                                          provider.filterColor == Colors.transparent
                                              ? provider.filterColor = Colors.white
                                              : provider.filterColor = Colors.transparent;
                                        },
                                      ),
                                    );
                                  }),
                                ),
                                const Text('置灰')
                              ],
                            ),
                          ),
                          child ?? const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          AppRoute.pushPage(context, const FontsSetting());
                        },
                        child: Row(
                          children: [
                            Text(
                              '字体:  ',
                              style: AppTextStyle.headLineMedium,
                            ),
                            Expanded(
                              child: Text(
                                context.read<ThemesProvider>().fontFamily ?? 'default',
                                style: AppTextStyle.titleMedium,
                              ),
                            ),
                          ],
                        )),
                    17.hSizedBox,
                    GridView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        ThemeGroup themeGroup = supportThemeGroups[index];
                        return GestureDetector(
                          onTap: () {
                            provider.currentThemeGroup = themeGroup;
                            HiveBoxes.put(HiveKey.colorThemeIndex, index);
                          },
                          child: FlutterColorsBorder(
                            available: themeGroup == provider.currentThemeGroup,
                            size: Size.infinite,
                            boardRadius: AppSize.radiusMedium,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSize.radiusMedium),
                              child: Container(
                                color: Constants.isDark ? themeGroup.darkThemeColor : themeGroup.lightThemeColor,
                                alignment: Alignment.center,
                                child: Text(themeGroup.name),
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10.w,
                        crossAxisSpacing: 10.h,
                        childAspectRatio: 2,
                      ),
                      itemCount: supportThemeGroups.length,
                      shrinkWrap: true,
                    )
                  ],
                );
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    Transform(
                      transform: Matrix4.identity()..scale(1.2),
                      alignment: Alignment.center,
                      child: Consumer<ThemesProvider>(builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Switch(
                            value: Constants.isDark,
                            activeColor: Colors.black,
                            inactiveThumbColor: Constants.isDark ? Colors.white.withOpacity(0.5) : Colors.white,
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
            15.hSizedBox,
            const _InformationContainer()
          ],
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
    ValueNotifier<Color> colorNotifier = ValueNotifier(provider.informationBgColor);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Information Background",
            style: AppTextStyle.bodyMedium,
          ),
          10.hSizedBox,
          ValueListenableBuilder(
              valueListenable: colorNotifier,
              builder: (context, Color color, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Container(
                    height: 90.h,
                    color: color,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: TextEditingController(text: "#${color.value.toRadixString(16)}"),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        isDense: true,
                      ),
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        print('textChange:$value');
                        if (value.length == 9 && value.contains("#")) {
                          int c = int.parse(value.replaceAll("#", ""), radix: 16);
                          colorNotifier.value = Color(c);
                        }
                      },
                    ),
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
                colorNotifier.value = context.read<ThemesProvider>().informationBgColor;
              }),
              resetButton(S.current.save, () {
                context.read<ThemesProvider>().informationBgColor = colorNotifier.value;
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget resetButton(String title, VoidCallback? onPressed) {
    return MaterialButton(
      height: AppSize.cellHeight,
      onPressed: onPressed,
      color: Colors.lightGreen,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

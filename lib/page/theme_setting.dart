//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-18 17:27:25
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_colors_border/flutter_colors_border.dart';
import 'package:nothing/constants/constants.dart';

class ThemeSettingPage extends StatelessWidget {
  final String title;

  const ThemeSettingPage(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<ThemesProvider>(
            builder: (context, provider, child) {
              return Container(
                height: 200,
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        provider.currentThemeGroup.name,
                        style: TextStyle(
                            color: Constants.isDark
                                ? provider.currentThemeGroup.darkThemeColor
                                : provider.currentThemeGroup.lightThemeColor,
                            fontSize: 25),
                      ),
                      alignment: Alignment.center,
                    ),
                    child ?? const SizedBox.shrink()
                  ],
                ),
                alignment: Alignment.center,
              );
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Transform(
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
            ),
          ),
          GridView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _ThemeContainer(
                context: context,
                themeGroup: supportThemeGroups[index],
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
        ],
      ),
    );
  }
}

class _ThemeContainer extends StatelessWidget {
  const _ThemeContainer({
    Key? key,
    required this.context,
    required this.themeGroup,
  }) : super(key: key);

  final BuildContext context;
  final ThemeGroup themeGroup;

  @override
  Widget build(BuildContext context) {
    double w = (Screens.width - 16 * 3) / 3;
    final Size size = Size(w, 80);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ThemesProvider>(
        builder: (context, provider, child) => GestureDetector(
          onTap: () {
            provider.currentThemeGroup = themeGroup;
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
                child: Text(themeGroup.name),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

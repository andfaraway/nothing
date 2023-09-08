import 'package:flutter/material.dart';

extension ColorExtension on Color {
  MaterialColor get swatch => Colors.primaries.firstWhere(
        (Color c) => c.value == value,
        orElse: () => _swatch,
      );

  MaterialColor get _swatch => MaterialColor(value, getMaterialColorValues);

  Map<int, Color> get getMaterialColorValues => <int, Color>{
        50: _swatchShade(50),
        100: _swatchShade(100),
        200: _swatchShade(200),
        300: _swatchShade(300),
        400: _swatchShade(400),
        500: _swatchShade(500),
        600: _swatchShade(600),
        700: _swatchShade(700),
        800: _swatchShade(800),
        900: _swatchShade(900),
      };

  Color _swatchShade(int swatchValue) => HSLColor.fromColor(this).withLightness(1 - (swatchValue / 1000)).toColor();

  Color get adaptiveColor => (red * 0.299 + green * 0.587 + blue * 0.144) > 186 ? Colors.black : Colors.white;
}

class HexColor extends Color {
  HexColor(super.value);

  factory HexColor.fromHex(String hexCode) {
    if (hexCode.length == 9) {
      hexCode = hexCode.replaceFirst('#', '0x');
    } else if (hexCode.length == 7) {
      hexCode = hexCode.replaceFirst('#', '0xFF');
    } else if (hexCode.length == 6) {
      hexCode = '0xFF$hexCode';
    } else {
      hexCode = '0xFFFFFFFF';
    }
    return HexColor(int.parse(hexCode));
  }
}

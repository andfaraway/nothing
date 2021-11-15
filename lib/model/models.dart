import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../constants/constants.dart';

part 'cloud_settings.dart';
part 'json_model.dart';
part 'theme_group.dart';
part 'user_info.dart';
part 'web_app.dart';


class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) =>
      child;
}

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nothing/common/constants.dart';
import 'package:provider/single_child_widget.dart';

import '../common/style.dart';
import '../http/api.dart';

export 'package:provider/provider.dart';

part 'download_provider.dart';
part 'home_provider.dart';
part 'launch_provider.dart';
part 'settings_provider.dart';
part 'themes_provider.dart';

ChangeNotifierProvider<T> buildProvider<T extends ChangeNotifier>(T value) {
  return ChangeNotifierProvider<T>.value(value: value);
}

List<SingleChildWidget> get providers => _providers;

final List<ChangeNotifierProvider<dynamic>> _providers = <ChangeNotifierProvider<dynamic>>[
  buildProvider<SettingsProvider>(SettingsProvider()),
  buildProvider<ThemesProvider>(ThemesProvider()),
  buildProvider<HomeProvider>(HomeProvider()),
  buildProvider<LaunchProvider>(LaunchProvider()),
  // buildProvider<DownloadProvider>(DownloadProvider()),
];

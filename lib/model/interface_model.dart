//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-11 17:31:44

import 'package:flutter/material.dart';

class InterfaceModel {
  final String? title;
  final String? url;
  final int? tag;
  final Widget? page;
  final void Function()? onTap;
  final void Function()? onLongPress;

  InterfaceModel(
      {this.title, this.url, this.tag, required this.page, this.onTap, this.onLongPress});

  static InterfaceModel fromJson(Map map) {
    return InterfaceModel(
        title: map['title'],
        url: map['url'],
        tag: map['tag'],
        page: map['page']);
  }
}

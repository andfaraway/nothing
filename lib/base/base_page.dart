import 'package:flutter/material.dart';

import 'base_state.dart';

///  需要参数传递的加以下参数
///  final String? arguments;
abstract class BasePage<S extends BaseState> extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  S createState() {
    return createBaseState();
  }

  S createBaseState();
}

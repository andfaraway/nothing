import 'package:flutter/material.dart';
import 'base_state.dart';

abstract class BasePage<S extends BaseState> extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  S createState() {
    return createBaseState();
  }

  S createBaseState();

}

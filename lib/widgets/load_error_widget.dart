import 'package:flutter/material.dart';

import '../generated/assets.dart';

class LoadErrorWidget extends StatelessWidget {
  const LoadErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(R.imagesLoadError),
    );
  }
}

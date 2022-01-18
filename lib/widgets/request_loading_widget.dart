//  网络请求loading
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-18 11:48:49
//

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RequestLoadingWidget extends StatelessWidget {
  const RequestLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCircle(color: Colors.white,
      size: 50.0,);
  }
}

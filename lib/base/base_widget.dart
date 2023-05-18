import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {
  final bool showLoading;
  final Widget contentWidget;
  final bool loadingShowContent;

  BaseWidget({Key? key, required this.contentWidget, this.showLoading = true, this.loadingShowContent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Visibility(
          visible: !showLoading || loadingShowContent,
          child: contentWidget,
        ),
        Visibility(
          visible: showLoading,
          child: Center(
            child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Image.asset('images/loading.gif')),
          ),
        ),
      ],
    );
  }
}

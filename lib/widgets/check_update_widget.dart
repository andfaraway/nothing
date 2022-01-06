//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-05 14:48:10
//
import 'package:flutter/material.dart';
import 'package:nothing/constants/constants.dart';
import 'flutter_white_button.dart';

typedef UpdateTapCallback = void Function();
typedef CancelCallback = void Function();

class CheckUpdateWidget extends StatelessWidget {
  final String title;
  final String content;
  final UpdateTapCallback? updateOnTap;
  final CancelCallback? cancelOnTap;

  const CheckUpdateWidget(
      {Key? key,
      this.title = '',
      this.content = '',
      required this.updateOnTap,
      this.cancelOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widgetWidth = Screens.width - 80;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: SizedBox(
          width: widgetWidth,
          height: widgetWidth * 948 / 827,
          child: Stack(
            children: [
              Image.asset('images/version_update.png'),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                    onTap: updateOnTap,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 60, bottom: 20),
                      child: Text(
                        'update',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                    onTap: cancelOnTap,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 60, bottom: 20),
                      child: Text(
                        'cancel',
                        style: TextStyle(color: Colors.orangeAccent, fontSize: 18),
                      ),
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }
}

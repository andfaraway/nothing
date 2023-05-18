//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-05 14:48:10
//
import 'package:nothing/common/prefix_header.dart';

typedef UpdateTapCallback = void Function();
typedef CancelCallback = void Function();

class CheckUpdateWidget extends StatelessWidget {
  final String title;
  final String content;
  final UpdateTapCallback? updateOnTap;
  final CancelCallback? cancelOnTap;

  const CheckUpdateWidget(
      {Key? key, this.title = 'version update', this.content = '', required this.updateOnTap, this.cancelOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widgetWidth = 640.w;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: SizedBox(
          width: 640.w,
          height: 734.h,
          child: Stack(
            children: [
              AppImage.asset(R.imagesVersionUpdate),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    250.hSizedBox,
                    Text(
                      title,
                      style: TextStyle(fontSize: 40.sp),
                    ),
                    50.hSizedBox,
                    Text(
                      content,
                      style: TextStyle(color: const Color.fromARGB(255, 176, 176, 176), fontSize: 30.sp),
                    ),
                  ],
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

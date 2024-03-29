//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-18 16:14:22
//
import 'package:nothing/common/constants.dart';
import 'package:nothing/common/style.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final void Function()? loginButtonPressed;

  const LoginButton(this.title, this.loginButtonPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w, right: 50.w, top: 15.h, bottom: Screens.bottomSafeHeight + 15.h),
      child: MaterialButton(
          onPressed: loginButtonPressed,
          color: AppColor.specialColor,
          shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(44.w))),
          child: Text(
            title,
            style: AppTextStyle.titleMedium.copyWith(color: AppColor.white),
          )),
    );
  }
}

//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-18 16:14:22
//
import 'package:nothing/constants/constants.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final Function loginButtonPressed;
  const LoginButton(this.title,this.loginButtonPressed,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 88.h,
      child: MaterialButton(
          onPressed: (){
            loginButtonPressed();
          },
          color: colorLoginButton,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 38.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(44.w)))),
    );
  }
}

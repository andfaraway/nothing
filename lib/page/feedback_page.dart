//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-17 16:09:34
//
import '/public.dart';
import 'package:nothing/widgets/login_button.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String content = '';
  String? nickname = Singleton.currentUser.username;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.feedback),
        ),
        backgroundColor: colorBackground,
        body: Padding(
          padding:
              EdgeInsets.only(left: 24.w, right: 24.w, top: 80.h, bottom: 80.h),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入您的意见和建议，我们会恰当采纳~',
                        hintStyle: TextStyle(
                            color: Color(0xFF999999), fontSize: 28.sp),
                        contentPadding: EdgeInsets.only(
                            left: 33.w, right: 33.w, top: 41.h, bottom: 41.h)),
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 28.sp, color: Colors.black),
                    onChanged: (value) {
                      content = value;
                      feedback1();
                    },
                    // maxLines: 10,
                  ),
                ),
                1.hDivider,
                SizedBox(
                  height: 80.h,
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('昵称:'),
                        10.wSizedBox,
                        Expanded(
                          child: Container(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: Singleton.currentUser.username,
                                  hintStyle: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 28.sp),
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true),
                              onChanged: (value) {
                                nickname = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 140.h),
          child: LoginButton(S.current.confirm, feedback.debounce()),
        ),
      ),
    );
  }

  feedback() async {
    if (content.isEmpty) {
      showCenterToast('反馈内容没有填哦😘');
      return null;
    }
    Constants.hideKeyboard(context);
    List? result = await API.addFeedback(content, nickname);
    if (result == null) {
      showToast('反馈失败');
    } else {
      showToast('反馈成功');
      setState(() {
        content = '';
        controller.text = content;
      });
    }
  }

  feedback1() async {
    if (content.isEmpty) return;
    await API.addFeedback(content, nickname);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}

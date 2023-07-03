//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-01-17 16:09:34
//
import 'package:nothing/widgets/login_button.dart';

import '../common/prefix_header.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String content = '';
  String? nickname = Singleton().currentUser.username;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(Singleton().currentUser);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.feedback),
        ),
        backgroundColor: AppColor.background,
        body: Padding(
          padding: AppPadding.main,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: '请输入您的意见和建议，我们也许会恰当采纳~',
                        hintStyle: AppTextStyle.bodyMedium.placeholderColor,
                        contentPadding: AppPadding.main),
                    textAlign: TextAlign.left,
                    style: AppTextStyle.bodyMedium,
                    onChanged: (value) => content = value,
                    // maxLines: 10,
                  ),
                ),
                1.hDivider,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.main.left, vertical: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '昵称:',
                        style: AppTextStyle.titleMedium,
                      ),
                      10.wSizedBox,
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(borderSide: BorderSide.none),
                              hintText: Singleton().currentUser.username,
                              hintStyle: AppTextStyle.titleMedium,
                              contentPadding: EdgeInsets.zero,
                              isDense: true),
                          textAlign: TextAlign.end,
                          onChanged: (value) {
                            nickname = value;
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: LoginButton(S.current.confirm, feedback.debounce()),
      ),
    );
  }

  feedback() async {
    if (content.isEmpty) {
      showCenterToast('反馈内容没有填哦😘');
      return null;
    }
    hideKeyboard(context);
    var result = await API.addFeedback(content, nickname);
    if (result.isSuccess) {
      showToast('反馈成功');
      setState(() {
        content = '';
        controller.text = content;
      });
    } else {
      showToast('反馈失败');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:nothing/common/prefix_header.dart';

class PrivacyDiaLog extends StatelessWidget {
  const PrivacyDiaLog(
      {Key? key, required this.userAgreementUrl, required this.privacyPolicyUrl, required this.continueCallback})
      : super(key: key);

  final String userAgreementUrl;
  final String privacyPolicyUrl;
  final VoidCallback continueCallback;

  final TextStyle linkStyle =
      const TextStyle(color: Colors.blue, decoration: TextDecoration.none, decorationColor: Colors.blue);

  final TextStyle defaultStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    InlineSpan span = TextSpan(children: [
      TextSpan(text: 'Nothing深知个人信息对您的重要性，因此我们将竭尽全力保障用忽的隐私信息安全\n\n', style: defaultStyle),
      TextSpan(text: '您可以阅读完整版', style: defaultStyle),
      TextSpan(
          text: '《用户协议》',
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Uri uri = Uri.parse(userAgreementUrl);
              if (!await launchUrl(uri)) {
                throw 'Could not launch $userAgreementUrl';
              }
            }),
      TextSpan(
          text: '《隐私政策》',
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              Uri uri = Uri.parse(privacyPolicyUrl);
              if (!await launchUrl(uri)) {
                throw 'Could not launch $privacyPolicyUrl';
              }
            }),
      TextSpan(text: '详细了解我们如何保护您的权益。\n\n', style: defaultStyle),
      TextSpan(text: '我们将严格按照政策要求使用和保护您的个人信息，如您统一以上内容，请点击同意，开始使用我们的产品与服务。\n', style: defaultStyle),
    ]);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black26,
        alignment: Alignment.center,
        child: Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: Colors.white),
          constraints: BoxConstraints(
            minWidth: Screens.width * 0.8,
            minHeight: 0,
            maxWidth: Screens.width * 0.8,
            maxHeight: Screens.height * 0.4,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text.rich(span),
                      ],
                    ),
                  ),
                ),
                15.hSizedBox,
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      continueCallback();
                    },
                    child: Text(
                      S.current.agree_continue,
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.cyan),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      exit(0);
                    },
                    child: Text(
                      S.current.disagree_quite,
                      style: const TextStyle(color: AppColor.blackLight),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-23 18:04:50
//

import '../common/prefix_header.dart';

class SayHi extends StatefulWidget {
  const SayHi({Key? key}) : super(key: key);

  @override
  _SayHiState createState() => _SayHiState();
}

class _SayHiState extends State<SayHi> {
  late String user;
  late String text;

  ///是否允许发送
  final ValueNotifier<bool> _canSend = ValueNotifier(true);

  late TextEditingController userCtl;
  late TextEditingController contentCtl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = HiveBoxes.get(HiveKey.hiToUser, defaultValue: 'biubiubiu');
    userCtl = TextEditingController(text: user);

    text = '😘';
    contentCtl = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              controller: userCtl,
              onChanged: (value) {
                user = value;
                HiveBoxes.put(HiveKey.hiToUser, value);
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.center,
                controller: TextEditingController(text: text),
                onChanged: (value) {
                  text = value;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              ValueListenableBuilder(
                valueListenable: _canSend,
                builder: (context, bool canSend, Widget? child) => MaterialButton(
                  color: canSend ? currentThemeGroup.themeColor : Colors.black54,
                  onPressed: sendBtnOnPressed,
                  child: const Text(
                    'send',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendBtnOnPressed() async {
    if (_canSend.value) {
      _canSend.value = false;
      await API.sayHello(user, text);
    }
    _canSend.value = true;
    showToast('发送成功');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _canSend.dispose();
  }
}

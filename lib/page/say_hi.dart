//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-23 18:04:50
//

import 'package:nothing/constants/constants.dart';
import 'package:flutter/material.dart';

class SayHi extends StatefulWidget {
  const SayHi({Key? key}) : super(key: key);

  @override
  _SayHiState createState() => _SayHiState();
}

class _SayHiState extends State<SayHi> {
  String user = 'biubiubiu';
  String text = '早';

  loadData() async {
    String? u = await LocalDataUtils.get(KEY_TO_USER);
    user = u ?? 'biubiubiu';
    userCtl = TextEditingController(text: user);
    setState(() {});
  }

  late TextEditingController userCtl;
  late TextEditingController contentCtl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    userCtl = TextEditingController(text: user);
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
                border: InputBorder.none,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Colors.white),
              controller: userCtl,
              onChanged: (value) {
                user = value;
                print('user = $user');
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
              MaterialButton(
                  child: const Text(
                    'send',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () async{
                    await UserAPI.sayHello(user, text);
                    await LocalDataUtils.setString(KEY_TO_USER,user);
                    showToast('发送成功');
                  }),

            ],
          ),
        ),
      ),
    );
  }
}

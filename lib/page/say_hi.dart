//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-12-23 18:04:50
//

import 'package:nothing/constants/constants.dart';
import 'package:flutter/material.dart';

class SayHi extends StatelessWidget {
  SayHi({Key? key}) : super(key: key);

  String text = '早';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SayHi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            textAlign: TextAlign.center,
            controller: TextEditingController(text: '早~'),
            onChanged: (value) {
              text = value;
            },
          ),
          SizedBox(height: 50,),
          MaterialButton(
              child: Text(
                'send',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () async {
                await UserAPI.sayHello('biubiubiu', text);
                showToast('发送成功');
              }),
        ],
      ),
    );
  }
}

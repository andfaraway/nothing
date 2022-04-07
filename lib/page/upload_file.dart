//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-06 15:53:41
//
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({Key? key}) : super(key: key);

  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.upload_file),
      ),
      body: Column(

      ),
    );
  }
}


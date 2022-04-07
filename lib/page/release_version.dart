//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2022-04-06 17:39:26
//
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class ReleaseVersion extends StatelessWidget {
  const ReleaseVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.release_version),
      ),
      body: Column(),
    );
  }
}


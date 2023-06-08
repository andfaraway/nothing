import 'package:nothing/common/prefix_header.dart';

class AppWidget {
  static PreferredSizeWidget appbar({String? title, Widget? titleWidget, List<Widget>? actions}) {
    return AppBar(
      title: titleWidget ?? Text(title ?? ''),
      actions: actions,
    );
  }
}

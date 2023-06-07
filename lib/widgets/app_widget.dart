import 'package:nothing/common/prefix_header.dart';

class AppWidget {
  static PreferredSizeWidget appbar({String? title, Widget? titleWidget}) {
    return AppBar(
      title: titleWidget ?? Text(title ?? ''),
    );
  }
}

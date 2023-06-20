export 'dart:io'
    if (dart.library.html) 'package:extended_image_library/src/_platform_web.dart'
    if (dart.library.html) 'dart:io';

export 'package:nothing/page/welcome_page.dart' if (dart.library.html) 'package:nothing/web/welcome_page_web.dart';

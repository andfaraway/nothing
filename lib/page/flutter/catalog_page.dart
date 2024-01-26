import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/page/flutter/flutter_cube.dart';
import 'package:nothing/page/flutter/flutter_isolate.dart';
import 'package:nothing/page/flutter/flutter_stream.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flutter'),
      ),
      body: Padding(
        padding: AppPadding.main,
        child: Column(
          children: [
            _titleCell(
                title: 'stream',
                onTap: () {
                  AppRoute.pushPage(context, const FlutterStream());
                }),
            _titleCell(
                title: 'Isolate',
                onTap: () {
                  AppRoute.pushPage(context, const FlutterIsolate());
                }),
            _titleCell(
                title: 'Cube',
                onTap: () {
                  AppRoute.pushPage(context, const FlutterCube());
                }),
          ],
        ),
      ),
    );
  }

  Widget _titleCell({Widget? icon, required String title, required VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.vertical),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ClayContainer(
          color: const Color(0xFFF2F2F2),
          curveType: CurveType.none,
          borderRadius: 75,
          customBorderRadius: BorderRadius.only(
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(18.r),
          ),
          depth: 10,
          // spread: 12,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal.w, vertical: AppPadding.horizontal.w),
            child: Center(
              child: Row(
                children: [
                  if (icon != null) icon,
                  AppPadding.horizontal.wSizedBox,
                  Text(
                    title,
                    style: AppTextStyle.titleMedium,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

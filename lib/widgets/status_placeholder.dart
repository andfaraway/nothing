import 'package:nothing/common/prefix_header.dart';

import '../http/http.dart';

enum StatusPlaceholderType {
  custom,
  empty,
  networkError,
  serverError,
}

extension StatusPlaceholderTypeEnumExt on StatusPlaceholderType {
  static Map<StatusPlaceholderType, String> rootTabTypeIconMap = {
    StatusPlaceholderType.custom: '',
    StatusPlaceholderType.empty: R.iconsFailure,
    StatusPlaceholderType.networkError: R.iconsFailure,
    StatusPlaceholderType.serverError: R.iconsFailure,
  };
  static Map<StatusPlaceholderType, Size> rootTabTypeIconSizeMap = {
    StatusPlaceholderType.custom: Size.zero,
    StatusPlaceholderType.empty: const Size(87.0, 91.0),
    StatusPlaceholderType.networkError: const Size(87.0, 91.0),
    StatusPlaceholderType.serverError: const Size(87.0, 91.0),
  };
  static Map<StatusPlaceholderType, String> rootTabTypeTitleMap = {
    StatusPlaceholderType.custom: '',
    StatusPlaceholderType.empty: '什么都没有',
    StatusPlaceholderType.networkError: '网络开小差了',
    StatusPlaceholderType.serverError: '服务器开小差了',
  };
  static Map<StatusPlaceholderType, String> rootTabTypeDescMap = {
    StatusPlaceholderType.custom: '',
    StatusPlaceholderType.empty: '点击屏幕刷新',
    StatusPlaceholderType.networkError: '点击屏幕刷新',
    StatusPlaceholderType.serverError: '点击屏幕刷新',
  };

  String get icon => rootTabTypeIconMap[this] ?? '';
  Size get iconSize => rootTabTypeIconSizeMap[this] ?? Size.zero;
  String get title => rootTabTypeTitleMap[this] ?? '';
  String get desc => rootTabTypeDescMap[this] ?? '';
}

StatusPlaceholderType? codeToStatusType(int? code, bool hasData) {
  if (hasData) {
    return null;
  }
  if (code == ResponseCode.normal) {
    return StatusPlaceholderType.empty;
  } else if (code == ResponseCode.networkError) {
    return StatusPlaceholderType.networkError;
  }
  return StatusPlaceholderType.serverError;
}

class StatusPlaceholder extends StatelessWidget {
  const StatusPlaceholder({Key? key,
    this.type = StatusPlaceholderType.custom,
    this.icon = '',
    this.iconSize,
    this.title = '',
    this.desc = '',
    this.width,
    this.height,
    this.alignment,
    this.color,
    this.onTap,
  }) : super(key: key);

  final StatusPlaceholderType? type;
  final String icon;
  final Size? iconSize;
  final String title;
  final String desc;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Color? color;
  final VoidCallback? onTap;

  String get _icon =>
      type == StatusPlaceholderType.custom ? icon : type?.icon ?? '';
  Size get _iconSize => type == StatusPlaceholderType.custom
      ? iconSize ?? Size(80.0.w, 80.0.w)
      : Size(type?.iconSize.width.w ?? 0.0, type?.iconSize.height.w ?? 0.0);
  String get _title =>
      type == StatusPlaceholderType.custom ? title : type?.title ?? '';
  String get _desc =>
      type == StatusPlaceholderType.custom ? desc : type?.desc ?? '';

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: type != null,
      child: InkWell(
        child: Container(
          color: color,
          width: width,
          height: height,
          alignment: alignment ?? const Alignment(0.0, -0.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: _icon.isNotEmpty,
                child: AppImage.asset(
                  _icon,
                  width: _iconSize.width,
                  height: _iconSize.height,
                ),
              ),
              Visibility(
                visible: _icon.isNotEmpty && _title.isNotEmpty,
                child: 20.0.hSizedBox,
              ),
              Visibility(
                visible: _title.isNotEmpty,
                child: Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: weightBold,
                    fontSize: 17.0.sp,
                    color: AppColor.mainColor,
                  ),
                ),
              ),
              Visibility(
                visible: _title.isNotEmpty && _desc.isNotEmpty,
                child: 6.hSizedBox,
              ),
              Visibility(
                visible: _desc.isNotEmpty,
                child: Text(
                  _desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 13.0.sp,
                    color: AppColor.secondlyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:nothing/common/prefix_header.dart';

class SearchBarWidget extends StatefulWidget {
  final String initText;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, this.onChanged, this.initText = ''});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Timer? _timer;
  late final TextEditingController _searchControl;

  @override
  void initState() {
    super.initState();
    _searchControl = TextEditingController(text: widget.initText);
  }

  @override
  void dispose() {
    super.dispose();
    _searchControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
      height: 38,
      alignment: Alignment.center,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 11.2, sigmaY: 11.2),
        child: TextField(
          controller: _searchControl,
          style: AppTextStyle.titleMedium,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide.none,
              ),
              constraints: BoxConstraints(maxHeight: 40.h),
              fillColor: AppColor.white.withOpacity(.3),
              contentPadding: EdgeInsets.zero,
              filled: true,
              hintText: '搜索',
              hintStyle: AppTextStyle.titleMedium
                  .copyWith(color: AppColor.mainColor.withOpacity(.5), fontWeight: weightMedium),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchControl.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        _searchControl.clear();
                        setState(() {});
                      },
                      child: const Icon(Icons.clear))
                  : null),
          onChanged: (value) {
            if (_timer?.isActive == true) {
              _timer?.cancel();
            }
            _timer = Timer(
                const Duration(milliseconds: 500),
                () {
                  widget.onChanged?.call(value);
                  _timer?.cancel();
                  setState(() {});
                }.throttle());
          },
        ),
      ),
    );
  }
}

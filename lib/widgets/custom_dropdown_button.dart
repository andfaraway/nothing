//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-11 17:08:22
//

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:nothing/public.dart';

class LDropdownButton extends StatelessWidget {
  final List<CustomMenuItem> items;
  final String initText;
  final Widget? icon;
  final List<CustomMenuItem> secondItems;
  final ValueChanged<String?>? onChanged;

  LDropdownButton(
      {Key? key,
      required this.items,
      required this.initText,
      this.secondItems = const [],
      this.icon,
      this.onChanged})
      : super(key: key);

  final ValueNotifier<String?> currentValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    currentValue.value = initText;
    items.last.divider = false;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: SizedBox(
          width: double.infinity,
          child: Center(
            child: ValueListenableBuilder(
              builder: (context, String? value, child) {
                return Text(
                  value ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                );
              },
              valueListenable: currentValue,
            ),
          ),
        ),
        // style: const TextStyle(color: Colors.white, fontSize: 24),
        icon: const SizedBox.shrink(),
        items: [
          ...items.map(
            (item) => DropdownMenuItem<CustomMenuItem>(
              value: item,
              child: CustomMenuItem.buildItem(context, item),
            ),
          ),
        ],
        onChanged: (CustomMenuItem? item) {
          currentValue.value = item?.text;
          onChanged?.call(item?.text);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        dropdownElevation: 4,
        offset: const Offset(0, 0),
      ),
    );
  }
}

class CustomMenuItem {
  final String? id;
  final String text;
  final String? count;
  bool divider;
  final int? index;
  final bool showManageIcon;

  CustomMenuItem(
      {required this.text,
      this.id,
      this.count,
      this.divider = true,
      this.index,
      this.showManageIcon = false});

  static Widget buildItem(BuildContext context, CustomMenuItem item) {
    return Center(
        child: Text(
      item.text,
    ));
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              SizedBox(
                width: 190.w,
                child: Text(
                  item.text,
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              item.count == null
                  ? const SizedBox.shrink()
                  : Text(
                      item.count.toString(),
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
            ],
          ),
        ),
        if (item.divider)
          const Align(
            alignment: Alignment.bottomCenter,
            child: Divider(
              color: Color(0xFFE8E8E8),
              height: .5,
              thickness: .5,
            ),
          )
      ],
    );
  }
}

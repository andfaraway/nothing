//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-11 17:08:22
//

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:nothing/common/prefix_header.dart';

class LDropdownButton extends StatelessWidget {
  final List<CustomMenuItem> items;
  final String initText;
  final Widget? icon;
  final List<CustomMenuItem> secondItems;
  final ValueChanged<String?>? onChanged;

  LDropdownButton({
    Key? key,
    required this.items,
    required this.initText,
    this.secondItems = const [],
    this.icon,
    this.onChanged,
  }) : super(key: key);

  final ValueNotifier<String?> currentValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    currentValue.value = initText;
    items.last.divider = false;
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        value: items.first,
        hint: SizedBox(
          width: double.infinity,
          child: Center(
            child: ValueListenableBuilder(
              builder: (context, String? value, child) {
                return Text(
                  value ?? '',
                  style: AppTextStyle.titleMedium,
                );
              },
              valueListenable: currentValue,
            ),
          ),
        ),
        style: AppTextStyle.titleMedium,
        disabledHint: const SizedBox.shrink(),
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
      {required this.text, this.id, this.count, this.divider = true, this.index, this.showManageIcon = false});

  static Widget buildItem(BuildContext context, CustomMenuItem item) {
    return Center(
      child: Text(
        item.text,
      ),
    );
  }
}

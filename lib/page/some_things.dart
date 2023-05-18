import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/widgets/custom_dropdown_button.dart';

import 'some_things_vm.dart';

class SomeThings extends BasePage<_SomeThingsState> {
  const SomeThings({Key? key}) : super(key: key);

  @override
  _SomeThingsState createBaseState() => _SomeThingsState();
}

class _SomeThingsState extends BaseState<SomeThingsVM, SomeThings> {
  @override
  SomeThingsVM createVM() => SomeThingsVM(context);

  @override
  void initState() {
    super.initState();
  }

  final AppRefreshController _controller = AppRefreshController(autoRefresh: true);
  int pageIndex = 0;
  int pageSize = 10;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget? getPageWidget() {
    return SizedBox(
      width: 200,
      height: 50,
      child: LDropdownButton(
        items: vm.pagesName.map((e) => CustomMenuItem(text: e)).toList(),
        initText: vm.currentPage,
        onChanged: (value) async {
          vm.currentPage = value ?? '';
          _controller.requestRefresh();
        },
      ),
    );
  }

  @override
  Widget createContentWidget() {
    return SafeArea(
      child: AppRefresher(
        onRefresh: _onRefresh,
        onLoading: _onLoad,
        controller: _controller,
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 10),
          itemBuilder: (context, i) {
            RecordModel model = vm.dataList[i];
            return ListTile(
              title: model.title == null
                  ? null
                  : Text(
                      model.title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
              subtitle: model.subTitle == null ? null : Text(model.subTitle!),
              trailing: model.trailingText == null
                  ? null
                  : Text(
                      model.trailingText!,
                      textAlign: TextAlign.center,
                    ),
            );
          },
          itemCount: vm.dataList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    pageIndex = 0;
    await vm.getData(pageIndex, pageSize, clean: true);
    setState(() {
      _controller.completed(success: true, resetFooterState: true);
    });
  }

  Future<void> _onLoad() async {
    pageIndex += 1;
    List<dynamic> data = await vm.getData(pageIndex, pageSize, clean: false);

    _controller.completed(success: true, noMore: data.isEmpty);
    setState(() {});
  }
}

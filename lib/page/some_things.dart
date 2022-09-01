import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:nothing/public.dart';
import 'package:nothing/widgets/custom_dropdown_button.dart';
import '../model/login_model.dart';
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

  final RefreshController _controller = RefreshController(initialRefresh: true);
  int pageIndex = 0;
  int pageSize = 50;

  @override
  Widget? getPageWidget() {
    return SizedBox(
      width: 200,
      height: 50,
      child: LDropdownButton(
        items: vm.pagesName.map((e) => CustomMenuItem(text: e)).toList(),
        initText: vm.currentPage,
        onChanged: (value) async{
          vm.currentPage = value ?? '';
          _controller.requestRefresh();
        },
      ),
    );
  }

  @override
  Widget createContentWidget() {
    return SafeArea(
      child: SmartRefresher(
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoad,
        controller: _controller,
        child: ListView.builder(
          itemBuilder: (context, i) {
            RecordModel model = vm.dataList[i];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  model.title.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(model.subTitle.toString()),
                trailing: Text(model.trailingText.toString()),
              ),
            );
          },
          itemCount: vm.dataList.length,
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    pageIndex = 0;
    await vm.getData(pageIndex, pageSize,clean: true);
    setState(() {
      _controller.refreshCompleted();
    });
  }

  Future<void> _onLoad() async {
    pageIndex += 1;
    List<dynamic> data = await vm.getData(pageIndex, pageSize, clean: false);
    if (data.isEmpty) {
      _controller.loadNoData();
      return;
    } else {
      setState(() {
        _controller.loadComplete();
      });
    }
  }
}

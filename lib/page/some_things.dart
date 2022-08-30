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
    return Container(
      // color: Colors.green,
      width: 200,
      height: 50,
      child: LDropdownButton(
        items: [CustomMenuItem(text: S.current.some_things)],
        onChanged: (value){
          print(value);
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
            Map<String, dynamic> map = vm.dataList[i];
            LoginModel model = LoginModel.fromJson(map);
            return ListTile(
              title: Text(
                model.username.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text('${model.date?.dataFormat(format: 'HH:mm:ss '
                  'yyyy/MM/dd')} ${model.network} ${model.battery}'),
              trailing: Text(model.version.toString()),
            );
          },
          itemCount: vm.dataList.length,
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    pageIndex = 0;
    await vm.getData(pageIndex, pageSize);
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

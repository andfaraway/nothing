import 'package:nothing/public.dart';
import 'package:nothing/model/login_model.dart';

class LoginsPage extends StatefulWidget {
  const LoginsPage({Key? key}) : super(key: key);

  @override
  State<LoginsPage> createState() => _LoginsPageState();
}

class _LoginsPageState extends State<LoginsPage> {
  List<LoginModel> logins = [];
  final RefreshController _controller = RefreshController();
  int currentPage = 0;
  int pageSize = 50;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.login_info),
      ),
      body: SafeArea(
        child: SmartRefresher(
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoad,
          controller: _controller,
          child: ListView.builder(
            itemBuilder: (context, i) {
              LoginModel model = logins[i];
              return ListTile(
                title: Text(
                  model.username.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text('${model.date?.dataFormat(format: 'hh:mm:ss '
                    'yyyy/MM/dd')} ${model.network} ${model.battery}'),
                trailing: Text(model.version.toString()),
              );
            },
            itemCount: logins.length,
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    currentPage = 0;
    logins.clear();
    List<dynamic> data = await API.getLogins(currentPage, pageSize);
    for (Map<String, dynamic> map in data) {
      LoginModel model = LoginModel.fromJson(map);
      logins.add(model);
    }
    setState(() {});
    _controller.refreshCompleted();
  }

  Future<void> _onLoad() async {
    currentPage += 1;
    List<dynamic> data = await API.getLogins(currentPage, pageSize);
    if (data.isEmpty) {
      _controller.loadNoData();
      return;
    }
    for (Map<String, dynamic> map in data) {
      LoginModel model = LoginModel.fromJson(map);
      logins.add(model);
    }
    setState(() {});
    _controller.loadComplete();
  }
}

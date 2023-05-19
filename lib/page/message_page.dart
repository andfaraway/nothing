import 'package:nothing/model/message_model.dart';
import 'package:nothing/widgets/request_loading_widget.dart';

import '../common/prefix_header.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late final AppRefreshController _refreshController = AppRefreshController(autoRefresh: true);

  List<MessageModel> dataList = [];

  @override
  void initState() {
    super.initState();
    loadData();

    globalContext = context;
  }

  Future<void> loadData() async {
    String? alias = HiveBoxes.get(HiveKey.pushAlias);
    List? list = await API.getMessages(alias);
    if (list == null) {
      showToast(S.current.request_failed);
      _refreshController.refreshCompleted();
      return;
    }

    dataList.clear();
    for (Map<String, dynamic> map in list) {
      MessageModel model = MessageModel.fromJson(map);
      dataList.add(model);
    }
    _refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(S.current.message),
      ),
      body: AppRefresher(
        onRefresh: () {
          loadData();
        },
        controller: _refreshController,
        child: dataList.isEmpty
            ? const RequestLoadingWidget()
            : ListView.builder(
                itemBuilder: (context, index) {
                  return messageWidget(dataList[index]);
                },
                itemCount: dataList.length,
                shrinkWrap: true,
              ),
      ),
    );
  }

  Widget messageWidget(MessageModel model) {
    return GestureDetector(
      onLongPress: () async {
        showConfirmToast(
            context: context,
            title: '确定删除吗？',
            onConfirm: () async {
              await API.deleteMessages(model.id.toString());
              loadData();
            });
      },
      child: Padding(
        padding: AppPadding.main,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(AppSize.radiusMedium)),
          ),
          child: Padding(
            padding: AppPadding.main,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        model.title ?? 'nothing',
                        style: AppTextStyle.titleMedium,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      model.date?.dataFormat() ?? '',
                      style: AppTextStyle.titleMedium.placeholderColor,
                    )
                  ],
                ),
                10.hSizedBox,
                model.type != 5
                    ? Text(
                        model.content ?? '',
                        style: AppTextStyle.bodyMedium,
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: Text(
                          model.content ?? '',
                          style: AppTextStyle.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

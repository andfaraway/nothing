import 'package:nothing/model/message_model.dart';
import 'package:nothing/widgets/request_loading_widget.dart';

import '../common/prefix_header.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> with AutomaticKeepAliveClientMixin {
  late final AppRefreshController _refreshController = AppRefreshController(autoRefresh: true);

  List<MessageModel> dataList = [];

  int _pageNum = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(S.current.message),
      ),
      body: AppRefresher(
        onRefresh: () {
          _pageNum = 0;
          _loadData();
        },
        onLoading: () {
          _pageNum++;
          _loadData();
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
              _loadData();
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
                      model.date?.dateFormat() ?? '',
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

  Future<void> _loadData() async {
    bool noMore = false;
    String? alias = HiveBoxes.get(HiveKey.pushAlias, defaultValue: '1');
    AppResponse response = await API.getMessages(alias: alias, pageNum: _pageNum);
    if (response.isSuccess) {
      if (_pageNum == 0) {
        dataList.clear();
      }
      if (response.dataList.isEmpty) {
        noMore = true;
      }
      for (Map<String, dynamic> map in response.dataList) {
        MessageModel model = MessageModel.fromJson(map);
        dataList.add(model);
      }
      setState(() {});
    }

    _refreshController.completed(success: response.isSuccess, noMore: noMore, resetFooterState: true);
  }

  @override
  bool get wantKeepAlive => true;
}

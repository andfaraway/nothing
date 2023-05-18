//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-16 18:49:44
//

import 'package:nothing/common/prefix_header.dart';

import '../constants/notification_center.dart';
import 'base_widget.dart';
import 'vm_s_contract.dart';

abstract class BaseState<VM extends BaseVM, T extends StatefulWidget> extends State
    with AutomaticKeepAliveClientMixin
    implements VMSContract {
  @override
  bool get wantKeepAlive => false;

  late VM _vm;
  bool _showLoading = false;
  bool _loadingShowContent = true;

  bool get showLoading => _showLoading;

  set showLoading(bool show) {
    _showLoading = show;
  }

  bool get loadingShowContent => _loadingShowContent;

  VM get vm => _vm;

  T get widget => super.widget as T;

  bool noData = false;

  ///键盘弹起页面是否自动上移
  bool resizeToAvoidBottomInset = true;

  ///标题
  String? pageTitle;

  ///背景颜色
  Color backgroundColor = AppColor.background;
  Color appBarBackgroundColor = Colors.white;

  ///点击空白是否收起键盘
  bool needHidKeyboard = false;

  ///pop后是否需要刷新界面
  bool popNeedRefresh = false;

  ///导航栏底部色块条高度
  double appBarLineHeight = 1;

  ///返回按钮
  Widget? backBtn;

  VM createVM();

  blankPage() {
    return Container();
  }

  // 标题widget
  Widget? getPageWidget() {
    return null;
  }

  ///右边按钮
  List<Widget>? appBarActions() {
    return null;
  }

  ///右下角添加按钮
  Widget? floatingActionButton() {
    return null;
  }

  ///底部bar
  bottomNavigationBar() {
    return null;
  }

  @override
  getShowLoadingCallback() {
    return (isShow) {
      setState(() {
        _showLoading = isShow;
      });
    };
  }

  @override
  getLoadingShowContentCallback() {
    return (isShow) {
      setState(() {
        _loadingShowContent = isShow;
      });
    };
  }

  @override
  notifyStateChanged() {
    return () {
      setState(() {});
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _vm.didChangeDependencies();
  }

  @override
  void initState() {
    Constants.context = context;
    super.initState();
    _vm = createVM()
      ..setupContract(this)
      ..setWidget(widget)
      ..setWidgetSetState(() {
        setState(() {});
      })
      ..init();
    //网络状态监测
    // NotificationCenter.instance.addObserver(NETWORK_CHANGE, (object){
    // setState(() {});
    // });

    //请求超时检查监测
    NotificationCenter().addObserver(NETWORK_TIME_OUT, (object) {
      setState(() {
        noData = true;
      });
    });
  }

  PreferredSizeWidget? createAppBar() {
    // return PreferredSize(
    //   preferredSize: Size.fromHeight(kToolbarHeight),
    //   child: SafeArea(
    //     child: Offstage(),
    //   ),
    // );
    return null;
  }

  ///带标题的Appbar
  createTitleAppBar() {
    return AppBar(
      title: getPageWidget() ??
          Text(
            pageTitle ?? '',
          ),
      centerTitle: true,
      elevation: 0,
      bottom: PreferredSize(
        child: Container(
          height: appBarLineHeight,
          color: AppColor.background,
        ),
        preferredSize: Size(double.infinity, 0),
      ),
      shadowColor: Color(0xFF010122).withOpacity(0.3),
      actions: appBarActions(),
      // leading: GestureDetector(
      //   behavior: HitTestBehavior.opaque,
      //   onTap: () {
      //     if (onWillPop == null) {
      //       FocusScope.of(context).requestFocus(FocusNode());
      //       Navigator.pop(context);
      //     } else {
      //       onWillPop?.call();
      //     }
      //   },
      //   child: SizedBox(
      //       width: 44,
      //       height: 44,
      //       child: Row(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(left: MARGIN_MAIN),
      //             child: backBtn ??
      //                 SvgPicture.asset(
      //                   R.iconsBtnBack,
      //                   width: 18.w,
      //                   height: 36.h,
      //                 ),
      //           ),
      //         ],
      //       )),
      // ),
    );
  }

  Widget createContentWidget();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      //防止因键盘弹出造成bottom overlowed by X pixels
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: pageTitle == null && getPageWidget() == null ? createAppBar() : createTitleAppBar(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: BaseWidget(
          contentWidget: noData
              ? blankPage()
              : needHidKeyboard
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        // 触摸收起键盘
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: createContentWidget())
                  : createContentWidget(),
          showLoading: _showLoading,
          loadingShowContent: _loadingShowContent,
        ),
      ),
      floatingActionButton: floatingActionButton(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (needHidKeyboard) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  WillPopCallback? onWillPop;

  @override
  void dispose() {
    super.dispose();
    _vm.dispose();
  }

  Widget defaultAppBarActions(
      {required String text,
      required Function()? onPressed,
      TextStyle? textStyle = const TextStyle(color: Colors.white)}) {
    return Center(
        child: SizedBox(
      height: 25,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.only(right: MARGIN_MAIN, left: MARGIN_MAIN)),
          alignment: Alignment.centerRight,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    ));
  }
}

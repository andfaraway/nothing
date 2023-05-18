import 'package:flutter/cupertino.dart';
import 'package:nothing/common/prefix_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'status_placeholder.dart';

class AppRefresher extends StatefulWidget {
  const AppRefresher({
    Key? key,
    this.controller,
    this.onRefresh,
    this.onLoading,
    this.onRefreshTap,
    this.child,
  }) : super(key: key);

  final AppRefreshController? controller;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final VoidCallback? onRefreshTap;
  final Widget? child;

  @override
  State<AppRefresher> createState() => _NineURefreshState();
}

class _NineURefreshState extends State<AppRefresher> {
  AppRefreshController? _refreshController;
  bool _enablePullDown = true;
  bool _enablePullUp = false;
  bool _footerHidden = false;
  StatusPlaceholderType? _statusType;

  AppRefreshController? get _effectiveController => widget.controller ?? _refreshController;

  void _config() {
    if (widget.controller == null) {
      _refreshController = AppRefreshController();
    }
    _effectiveController?.headerMode?.addListener(() {
      if (_effectiveController?.isRefresh == true) {
        _effectiveController?.resetStatusType();
        if (_enablePullUp) {
          if (mounted) {
            setState(() {
              _enablePullUp = false;
            });
          }
        }
      }
      if (_effectiveController?.headerMode?.value == RefreshStatus.completed) {
        if (widget.onLoading != null && !_enablePullUp && _statusType == null) {
          if (mounted) {
            setState(() {
              _enablePullUp = true;
            });
          }
        }
      }
    });
    _effectiveController?.footerMode?.addListener(() {
      if (_effectiveController?.isLoading == true) {
        if (_enablePullDown) {
          if (mounted) {
            setState(() {
              _enablePullDown = false;
            });
          }
        }
      }
      if (_effectiveController?.isLoading == false) {
        if (!_enablePullDown) {
          if (mounted) {
            setState(() {
              _enablePullDown = true;
            });
          }
        }
      }
    });
    _effectiveController?.footerHidden.addListener(() {
      if (mounted) {
        setState(() {
          _footerHidden = _effectiveController?.footerHidden.value ?? false;
        });
      }
    });
    _effectiveController?.statusType.addListener(() {
      if (mounted) {
        setState(() {
          _statusType = _effectiveController?.statusType.value;
          if (_enablePullUp && _statusType != null) {
            _enablePullUp = false;
          }
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_effectiveController?.autoRefresh == true) {
        if (mounted) {
          _effectiveController?.toRefresh(needMove: false);
        }
      }
    });
  }

  void _onRefreshTap() {
    if (widget.onRefreshTap is VoidCallback) {
      widget.onRefreshTap!();
      return;
    }
    _effectiveController?.toRefresh();
  }

  @override
  void initState() {
    super.initState();

    _config();
  }

  @override
  void dispose() {
    super.dispose();

    _refreshController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        if (_effectiveController == null) {
          return Container();
        }
        return SmartRefresher(
          controller: _effectiveController!,
          enablePullDown: _enablePullDown,
          enablePullUp: _enablePullUp,
          header: ClassicHeader(
            height: 68.0.h,
            spacing: 8.0.w,
            textStyle: TextStyle(
              fontSize: 15.0.sp,
              color: AppColor.secondlyColor,
            ),
            idleText: '下拉刷新',
            releaseText: '松开刷新',
            refreshingText: '刷新中...',
            completeText: '刷新完成',
            failedText: '刷新失败',
            refreshingIcon: SizedBox(
              width: 22.0.w,
              height: 22.0.w,
              child: const CupertinoActivityIndicator(),
            ),
            failedIcon: Icon(
              Icons.error,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
            completeIcon: Icon(
              Icons.done,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
            idleIcon: Icon(
              Icons.arrow_downward,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
            releaseIcon: Icon(
              Icons.refresh,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
          ),
          footer: ClassicFooter(
            height: 68.0.h,
            spacing: 8.0.w,
            textStyle: TextStyle(
              fontSize: 15.0.sp,
              color: _footerHidden ? Colors.transparent : AppColor.secondlyColor,
            ),
            idleText: '上拉加载',
            canLoadingText: '松开加载',
            loadingText: '加载中...',
            noDataText: '全部加载完毕',
            failedText: '加载失败',
            failedIcon: Icon(
              Icons.error,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
            loadingIcon: SizedBox(
              width: 22.0.w,
              height: 22.0.w,
              child: const CupertinoActivityIndicator(),
            ),
            canLoadingIcon: Icon(
              Icons.autorenew,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
            idleIcon: Icon(
              Icons.arrow_upward,
              size: 22.0.w,
              color: AppColor.secondlyColor,
            ),
          ),
          onRefresh: widget.onRefresh,
          onLoading: widget.onLoading,
          child: _statusType != null
              ? CustomScrollView(
                  slivers: <Widget>[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: StatusPlaceholder(
                        type: _statusType,
                        onTap: _onRefreshTap,
                      ),
                    ),
                  ],
                )
              : widget.child,
        );
      },
    );
  }
}

class AppRefreshConfiguration extends RefreshConfiguration {
  AppRefreshConfiguration({Key? key, required Widget child})
      : super(
          key: key,
          child: child,
          headerBuilder: () => WaterDropHeader(
            complete: const Icon(
              Icons.done,
              color: Colors.grey,
            ),
            waterDropColor: AppColor.mainColor,
          ),
          footerBuilder: () => const ClassicFooter(),
          // headerTriggerDistance: 75.0.h,
          // footerTriggerDistance: 15.0.h,
        );
}

class AppRefreshController extends RefreshController {
  final bool autoRefresh;
  final ValueNotifier<bool> footerHidden = ValueNotifier<bool>(false);
  final ValueNotifier<StatusPlaceholderType?> statusType = ValueNotifier<StatusPlaceholderType?>(null);

  bool get isRequest {
    return isRefresh || isLoading;
  }

  void resetStatusType() {
    statusType.value = null;
  }

  void setStatusType(StatusPlaceholderType? state) {
    statusType.value = state;
  }

  Future<bool> toRefresh({bool needMove = true}) async {
    if (isRequest) {
      return Future.value(false);
    }
    await super.requestRefresh(
      duration: Duration(milliseconds: needMove ? 500 : 1),
    );
    return Future.value(true);
  }

  @override
  void refreshCompleted({
    bool success = true,
    bool resetFooterState = false,
  }) {
    footerHidden.value = !resetFooterState;
    success ? super.refreshCompleted(resetFooterState: resetFooterState) : super.refreshFailed();
    if (!resetFooterState) {
      super.loadNoData();
    }
  }

  void loadCompleted({
    bool success = true,
    bool noMore = false,
  }) {
    success
        ? noMore
            ? super.loadNoData()
            : super.loadComplete()
        : super.loadFailed();
  }

  void completed({
    bool success = true,
    bool resetFooterState = false,
    bool noMore = false,
  }) {
    if (isLoading) {
      loadCompleted(success: success, noMore: noMore);
    } else {
      refreshCompleted(success: success, resetFooterState: resetFooterState);
    }
  }

  @override
  void dispose() {
    super.dispose();

    footerHidden.dispose();
    statusType.dispose();
  }

  AppRefreshController({
    this.autoRefresh = false,
  });
}

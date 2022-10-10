//
//  [Author] libin (https://www.imin.sg)
//  [Date] 2022-02-16 18:49:44
//

import 'package:flutter/cupertino.dart';
import 'vm_s_contract.dart';

abstract class BaseVM {
  final BuildContext _context;

  BuildContext get context => _context;

  BaseVM(this._context);

  late Function widgetSetState;

  ValueChanged<bool>? _showLoading;
  ValueChanged<bool>? _loadingShowContent;
  VoidCallback? _notifyStateChanged;

  ValueChanged<bool>? get showLoading => _showLoading;

  ValueChanged<bool>? get loadingShowContent => _loadingShowContent;

  VoidCallback? get notifyStateChanged => _notifyStateChanged;

  late StatefulWidget widget;
  void setWidget(StatefulWidget s){
    widget = s;
  }

  void setWidgetSetState(Function fun) {
    widgetSetState = fun;
  }

  void setupContract(VMSContract contract) {
    _showLoading = contract.getShowLoadingCallback();
    _loadingShowContent = contract.getLoadingShowContentCallback();
    _notifyStateChanged = contract.notifyStateChanged();
  }

  Future<void> loadData() async {}

  void init();

  void dispose() {
    // print('${this.context} vm dispose');
  }

  void didChangeDependencies() {}

  Future<void> next() async => {};

}

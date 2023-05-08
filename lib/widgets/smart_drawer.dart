//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-12 12:07:22
//
import 'package:flutter/foundation.dart';
import 'package:nothing/constants/constants.dart';

class SmartDrawer extends StatefulWidget {
  final double elevation;
  final Widget? child;
  final String? semanticLabel;
  final double widthPercent;
  final DrawerCallback? callback;
  const SmartDrawer({
    Key? key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.widthPercent = 0.8,

    ///add start
    this.callback,

    ///add end
  })  : assert(widthPercent < 1.0 && widthPercent > 0.0),
        super(key: key);

  @override
  State<SmartDrawer> createState() => _SmartDrawerState();
}

class _SmartDrawerState extends State<SmartDrawer> {
  @override
  void initState() {
    ///open
    widget.callback?.call(true);
    super.initState();
  }

  @override
  void dispose() {
    ///close
    widget.callback?.call(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utils.hideKeyboard(context);
    assert(debugCheckHasMaterialLocalizations(context));
    String? label = widget.semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = widget.semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = widget.semanticLabel ?? MaterialLocalizations.of(context).drawerLabel;
        break;
      default:
    }
    final double width = MediaQuery.of(context).size.width * widget.widthPercent;
    // return widget.child ?? const SizedBox.shrink();
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: width),
        child: Material(
          elevation: widget.elevation,
          child: widget.child,
        ),
      ),
    );
  }
}

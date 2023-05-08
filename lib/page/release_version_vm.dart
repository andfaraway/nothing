import 'package:nothing/common/prefix_header.dart';
import 'package:nothing/model/version_update_model.dart';

class ReleaseVersionVM extends BaseVM {
  ReleaseVersionVM(BuildContext context) : super(context);

  VersionUpdateModel? model;
  String? tempId;

  @override
  void init() {
    getLastVersionInfo();
  }

  Future<void> save(bool sendNotification) async {
    if (model == null) return;
    if(tempId == model!.id){
      await API.updateVersionInfo(model!);
    }else{
      await API.addVersionInfo(model!);
    }
    if(sendNotification){
      await API.versionUpdateNotification(model!);
    }
    showToast(S.current.success);
  }

  Future<void> updateVersionInfo() async {
    if (model == null) return;
    await API.updateVersionInfo(model!);
    showToast(S.current.success);
  }

  /// 检查更新
  Future<void> getLastVersionInfo() async {
    String version = await DeviceUtils.version();
    Map<String, dynamic> data = await API.checkUpdate('ios', version) ?? {};
    model = VersionUpdateModel.fromJson(data);
    tempId = model?.id;
    widgetSetState();
  }
}

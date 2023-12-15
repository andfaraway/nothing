part of 'models.dart';

@HiveType(typeId: HiveAdapterTypeIds.dragIconModel)
class DragIconModel extends HiveObject {
  DragIconModel({
    this.dx = 0,
    this.dy = 0,
    this.width = 88,
    this.height = 88,
  });

  factory DragIconModel.fromJson(Map<String, dynamic> json) {
    return DragIconModel(
      dx: json['dx'],
      dy: json['dy'],
      width: json['width'],
      height: json['height'],
    );
  }

  @HiveField(0)
  double dx;
  @HiveField(1)
  double dy;
  @HiveField(2)
  double width;
  @HiveField(3)
  double height;

  Offset get offset => Offset(dx, dy);

  Size get size => Size(width, height);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dx': dx,
      'dy': dy,
      'width': width,
      'height': height,
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

import '../../common/prefix_header.dart';

class OverflowBoxPage extends StatelessWidget {
  const OverflowBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OverflowBox'),
      ),
      body: Column(
        children: [
          200.hSizedBox,
          GestureDetector(
            onTap: () {
              print('123');
            },
            child: Container(
              height: 50,
              width: double.infinity,
              color: AppColor.randomColor,
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            color: AppColor.randomColor,
            child: overflowWidget(),
          ),
        ],
      ),
    );
  }

  Widget overflowWidget() {
    return OverflowBox(
      alignment: Alignment.center,
      minHeight: 600,
      minWidth: 200,
      maxWidth: 200,
      maxHeight: 600,
      child: Container(
        width: 400,
        height: 400,
        color: AppColor.randomColor,
      ),
    );

    return Align(
      alignment: Alignment.topRight,
      child: Transform.translate(
        offset: Offset(0, -100),
        child: Container(
          color: AppColor.randomColors.first,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}

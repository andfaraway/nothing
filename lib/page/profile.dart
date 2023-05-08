import 'package:nothing/common/prefix_header.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<double> _scrollOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // controller: _scrollController,
      // physics: const ClampingScrollPhysics(),
      slivers: [
        // SliverToBoxAdapter(
        //   child: ValueListenableBuilder(
        //     valueListenable: _scrollOffset,
        //     builder: (BuildContext context, double value, Widget? child) {
        //       return SizedBox(height:190+value,child: AppImage.network('http://1.14.252.115/src/handsomeman.jpeg',fit: BoxFit.fitWidth,));
        //     },
        //   ),
        // ),
        // SliverAppBar(
        //   stretch: true,
        //   pinned: true,
        //   // toolbarHeight:200,
        //   expandedHeight: 390 ,
        //   flexibleSpace: FlexibleSpaceBar(
        //     centerTitle: false,
        //     // titlePadding:EdgeInsets.zero,
        //     title: Container(
        //       color: Colors.red,
        //       child: Text("First FlexibleSpace",style: TextStyle(color: Colors.black),),
        //     ),
        //     stretchModes: [
        //       // StretchMode.fadeTitle,
        //       // StretchMode.blurBackground,
        //       StretchMode.zoomBackground
        //     ],
        //     background: AppImage.network('http://1.14.252.115/src/handsomeman.jpeg',fit: BoxFit.cover),
        //   ),
        // ),
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              "First FlexibleSpace",
              style: TextStyle(color: Colors.black),
            ),
            // collapseMode: CollapseMode.pin,
            background: Image.network(
                "https://p3-passport.byteimg.com/img/user-avatar/af5f7ee5f0c449f25fc0b32c050bf100~180x180.awebp",
                fit: BoxFit.cover),
          ),
          actions: <Widget>[IconButton(onPressed: () => null, icon: const Icon(Icons.add))],
        ),

        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              color: getRandomColor(),
              height: 50,
              width: 100,
            );
          }),
          itemExtent: 60,
        )
      ],
    );
  }
}

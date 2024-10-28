import 'package:nothing/common/prefix_header.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nothing/model/server_image_model.dart';

class PhotoPreview extends StatefulWidget {
  const PhotoPreview({super.key});

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> with TickerProviderStateMixin {
  List<ServerImageModel> photos = [];

  ServerImageModel? currentImage;

  late AnimationController _animationController;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _request();
  }

  @override
  dispose() {
    super.dispose();
    _animationController.dispose();
    _pageController.dispose();
  }

  _request() async {
    photos = List.generate(30, (index) {
      return ServerImageModel()..temp = AppImage.randomUrl(id: index++, size: 750);
    }).toList();

    setState(() {});
    return;

    final response = await API.getImages('wedding/20241004');
    if (response.isSuccess) {
      photos = response.dataList.map((e) => ServerImageModel.fromJson(e)).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppWidget.appbar(
        title: currentImage?.name,
        actions: [
          IconButton(
            onPressed: _request,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          print('page = $page');
        },
        children: photos.map((e) {
          return SizedBox(
            width: Screens.width,
            height: Screens.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AppImage.network(
                    e.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      // body: Container(
      //   color: Colors.white,
      //   child: Center(
      //     child: AppImage.network(
      //       currentImage?.imageUrl,
      //       width: double.infinity,
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: _bottomWidget(),
    );
  }

  Widget _bottomWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: Screens.bottomSafeHeight, top: 12, left: 32, right: 32),
      child: SizedBox(
        height: 30,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 3,
            childAspectRatio: 30 / 20,
          ),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print(photos[index].imageUrl);

                _pageController.jumpToPage(index);
                setState(() {
                  currentImage = photos[index];
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: AppColor.randomColors[index % 3],
                  child: AppImage.network(photos[index].imageUrl, width: 50, height: 50),
                ),
              ),
            );
          },
          itemCount: photos.length,
          shrinkWrap: true,
        ),
      ),
    );
  }
}

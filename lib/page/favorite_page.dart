//
//  [Author] libin (https://github.com/andfaraway/nothing)
//  [Date] 2021-11-12 18:04:14
//

import 'package:nothing/constants/constants.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('❤️'),),
      body: Column(
        children: favoriteList.map((e){
          return ListTile(title: Text(e),);
        }).toList(),
      ),
    );
  }
}

import 'package:nothing/public.dart';

class WeddingAbout extends StatefulWidget {
  const WeddingAbout({Key? key}) : super(key: key);

  @override
  State<WeddingAbout> createState() => _WeddingAboutState();
}

class _WeddingAboutState extends State<WeddingAbout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wedding'),
        actions: [
          IconButton(
              onPressed: () {
                addOneThing();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(itemBuilder: (context,i){
        return checkCell(true, 'title', (value) { });
      },itemCount: 5,)
    );
  }

  Widget checkCell(bool value,String title,ValueChanged<bool?>? onChanged){
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value){}),
        Text(title)
      ],
    );
  }

  Future<void> addOneThing() async {}
}

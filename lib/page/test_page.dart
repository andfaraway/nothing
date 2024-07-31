import '../common/constants.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset(
          //   key: UniqueKey(),
          //   R.lottieLoading,
          //   width: double.infinity,
          //   // repeat: true,
          //   // reverse: true,
          //     onLoaded:(lottieComposition){
          //     print(lottieComposition.name);
          //     }
          // ),
          Center(
            child: TextButton(
                onPressed: () {
                  ToastUtils.init();
                  ToastUtils.showLoading();
                  Future.delayed(const Duration(seconds: 3), () => ToastUtils.hideLoading());
                },
                child: const Text('click')),
          ),
        ],
      ),
    );
  }
}

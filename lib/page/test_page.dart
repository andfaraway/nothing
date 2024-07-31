import 'package:lottie/lottie.dart';

import '../common/constants.dart';
import '../generated/assets.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          R.lottieLoading,
          width: 80,
          height: 80,
          repeat: true,
        ),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:magazine/common/utils/session.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            height: size.height,
            width: size.width,
            'assets/images/main_page_bg.png',
            fit: BoxFit.cover,
          ),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 15),
                child: CloseButton(),
              )),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonCustom(
                    onClick: () async {
                      await authController.getout();

                      try {
                        final user = await authController.login();

                        if (user == null) {
                          Fluttertoast.showToast(
                              backgroundColor: Colors.red, msg: "Gagal Masuk");
                        } else {
                          print(user.id);
                          print(user.photoUrl);
                          Session.saveGooglePhoto(user.photoUrl);
                          await authController.cbLogin(
                              user.id, user.email, user.displayName);
                        }
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to sign in with Google');
                      }
                    },
                    text: 'Masuk dengan Google',
                    visible: true,
                    prefix: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/icons/google.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

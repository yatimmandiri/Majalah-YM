import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';

class VerifyPhonePage extends StatelessWidget {
  VerifyPhonePage({super.key, this.user});

  final GoogleSignInAccount? user;

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                InputForm(
                  hintText: '08xxx',
                  controller: authController.nomorC,
                  label: Text(
                    'Nomor whatsapp',
                    style: fMd.copyWith(color: Colors.grey),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  if (authController.loading) {
                    return TextButton(
                      onPressed: () {},
                      child: CircularProgressIndicator(
                        color: BaseColor.secondary,
                      ),
                    );
                  }
                  return ButtonCustom(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: BaseColor.secondary)),
                    textColor: BaseColor.secondary,
                    backgroundColor: Colors.white,
                    text: 'Verifikasi',
                    onClick: () async {
                      // String nomor = authController.nomorC.text.trim();
                      // if (nomor != '') {
                      //   if (authController.isValidWhatsAppNumber(nomor)) {
                      //     await authController.cbLogin(
                      //         user!.id, user!.email, user!.displayName, nomor);
                      //   } else {
                      //     Fluttertoast.showToast(
                      //         backgroundColor: Colors.red,
                      //         msg: "Nomor WhatsApp tidak valid");
                      //   }
                      // } else {
                      //   Fluttertoast.showToast(
                      //       backgroundColor: Colors.red,
                      //       msg: "Isi nomor WhatsApp");
                      // }
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

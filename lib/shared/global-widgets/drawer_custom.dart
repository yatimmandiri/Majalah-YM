import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/common/utils/session.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/auth/data/model/user_model.dart';
import 'package:magazine/features/auth/pages/profile_page.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/dialog_custom.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class DrawerCustom extends StatelessWidget {
  DrawerCustom({super.key, this.email, this.img, this.user});

  final String? img;
  final String? email;
  final UserItem? user;

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Drawer(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (email != null) ...[
          Column(
            children: [
              DrawerHeader(
                  child: Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: ExtendedImage.network(
                        img ?? 'https://via.placeholder.com/100',
                        fit: BoxFit.cover,
                        handleLoadingProgress: true,
                        width: 90,
                        height: 90,
                        loadStateChanged: (state) {
                          if (state.extendedImageLoadState ==
                              LoadState.failed) {
                            return AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Material(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey[300],
                                  child:
                                      const Icon(Icons.broken_image_outlined),
                                ));
                          }

                          if (state.extendedImageLoadState ==
                              LoadState.loading) {
                            return LoadingCustom(
                                radius: 90, height: 90, width: 90);
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(email ?? 'Not Identified')
                  ],
                ),
              )),
              ListTile(
                title: const Text('PROFIL'),
                leading: const Icon(Icons.person),
                onTap: () {
                  Get.to(
                      () => ProfilePage(
                            imgUrl: img,
                          ),
                      arguments: user);
                },
              ),
              ListTile(
                title: const Text('PENGATURAN'),
                leading: const Icon(Icons.settings_applications_outlined),
                onTap: () {
                  Get.toNamed(AppRoutes.setting);
                },
              ),
            ],
          ),
        ],
        Padding(
          padding: EdgeInsets.only(
              top: email != null ? 0 : size.height * .45, bottom: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() {
              if (authController.loading) {
                return TextButton(
                  onPressed: () {},
                  child: CircularProgressIndicator(
                    color: BaseColor.secondary,
                  ),
                );
              }
              return ButtonCustom(
                onClick: () async {
                  if (authController.isAuthenticated) {
                    DialogCustom.showConfirmationDialog(
                      'Konfirmasi',
                      'Yakin anda ingin keluar?',
                      () {
                        authController.logout();
                      },
                    );
                  } else {
                    await authController.getout();
                    try {
                      final user = await authController.login();

                      if (user == null) {
                        Fluttertoast.showToast(
                            backgroundColor: Colors.red, msg: "Gagal masuk");
                      } else {
                        print(user.id);
                        Session.saveGooglePhoto(user.photoUrl);
                        await authController.cbLogin(
                            user.id, user.email, user.displayName);
                      }
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to sign in with Google');
                    }
                  }
                },
                text: authController.isAuthenticated ? 'Keluar' : 'Masuk',
                backgroundColor: authController.isAuthenticated
                    ? Colors.red
                    : BaseColor.secondary,
                borderRadius: 20,
              );
            }),
          ),
        )
      ]),
    );
  }
}

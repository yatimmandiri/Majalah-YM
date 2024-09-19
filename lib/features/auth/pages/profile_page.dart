import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/auth/data/model/user_model.dart';
import 'package:magazine/shared/global-widgets/background_widget.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key, this.imgUrl});

  final UserItem user = Get.arguments;
  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWidget(),
          SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: BackButtonCustom(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 100,
                      width: 125,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: BaseColor.secondary, width: 3),
                                  shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: ExtendedImage.network(
                                  imgUrl ?? 'https://via.placeholder.com/100',
                                  fit: BoxFit.cover,
                                  handleLoadingProgress: true,
                                  width: 100,
                                  height: 100,
                                  loadStateChanged: (state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.failed) {
                                      return AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: Colors.grey[300],
                                            child: const Icon(
                                                Icons.broken_image_outlined),
                                          ));
                                    }

                                    if (state.extendedImageLoadState ==
                                        LoadState.loading) {
                                      return const LoadingCustom(
                                          radius: 100, height: 100, width: 100);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 65),
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                                onPressed: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text('Update Foto Profile'),
                                      content: const Text(
                                          'Fitur ini masih belum bisa digunakan'),
                                      backgroundColor: Colors.white,
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                  );
                                },
                                icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: BaseColor.secondary,
                                        borderRadius:
                                            BorderRadius.circular(23)),
                                    child: const Icon(
                                      Icons.photo_camera_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ))),
                          )
                        ],
                      ),
                    ),
                    Text(
                      user.name ?? '',
                      style: fMd.copyWith(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 20,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.mail,
                            color: BaseColor.secondary,
                            size: 40,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: fMd,
                                ),
                                Text(
                                  user.email ?? '',
                                  style: fMd.copyWith(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(10, 10),
                            blurRadius: 20,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.phone,
                            color: BaseColor.secondary,
                            size: 40,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nomor',
                                  style: fMd,
                                ),
                                Text(
                                  user.handphone ?? '',
                                  style: fMd.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

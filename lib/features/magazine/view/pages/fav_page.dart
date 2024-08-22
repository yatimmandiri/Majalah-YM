import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/common/utils/session.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/view/widgets/fav_card.dart';
import 'package:magazine/features/magazine/view/widgets/magazine_card.dart';
import 'package:magazine/shared/global-widgets/background_widget.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/drawer_custom.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';
import 'package:magazine/shared/global-widgets/navbar_bottom.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final cMagazine = Get.put(MagazineController());
  final cAuth = Get.put(AuthController());
  String? imgUrl;

  @override
  void initState() {
    cMagazine.loadMagazineFav();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: Obx(() {
        Session.getGooglePhoto().then((res) {
          setState(() {
            imgUrl = res;
          });
        });
        return DrawerCustom(
          email: cAuth.dataUser.email,
          img: imgUrl,
          user: cAuth.dataUser,
        );
      }),
      body: Stack(
        children: [
          BackgroundWidget(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * .06),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Favorit Saya',
                        style: fXl.copyWith(color: Colors.white),
                      ),
                      if (!cAuth.isAuthenticated) ...[
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          padding: EdgeInsets.all(8),
                          child: InkWell(
                              onTap: () async {
                                await cAuth.getout();
                                try {
                                  final user = await cAuth.login();

                                  if (user == null) {
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.red,
                                        msg: "Gagal login");
                                  } else {
                                    print(user.id);
                                    Session.saveGooglePhoto(user.photoUrl);
                                    await cAuth.cbLogin(
                                        user.id, user.email, user.displayName);
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                      'Error', 'Failed to sign in with Google');
                                }
                              },
                              child: Icon(
                                Icons.logout_rounded,
                                color: BaseColor.primary,
                              )),
                        )
                      ] else ...[
                        Builder(builder: (ctx) {
                          return Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Scaffold.of(ctx).openDrawer();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/menu.svg',
                                    color: BaseColor.primary,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ));
                        }),
                      ]
                    ],
                  ),
                ),
                GetBuilder<MagazineController>(
                  builder: (_) {
                    if (!cAuth.isAuthenticated) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 40, horizontal: 20),
                        child: ButtonCustom(
                            onClick: () {
                              Get.toNamed(AppRoutes.login);
                            },
                            text: 'Login dulu yuk'),
                      );
                    }
                    if (_.loading) {
                      return SizedBox(
                        height: size.height * .3,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: const LoadingCustom(
                                height: 60,
                                width: double.infinity,
                                radius: 20,
                              ),
                            );
                          },
                        ),
                      );
                    }

                    if (_.dataCacheMagazine.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: BlankItem(),
                      );
                    }
                    return SizedBox(
                      height: _.dataCacheMagazine.length * 100,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        itemCount: _.dataCacheMagazine.length,
                        itemBuilder: (context, index) {
                          MagazineItem data = _.dataCacheMagazine[index];
                          return FavCard(
                            img: '${Endpoint.storage}/${data.cover}',
                            title: data.name,
                            onTap: () => Get.toNamed(AppRoutes.detailMagazine,
                                arguments: data),
                            onPressed: () {
                              if (cAuth.isAuthenticated) {
                                _.addOrRemoveMagazine(data).then((value) {
                                  if (value) {
                                    _.loadMagazineFav();
                                  }
                                });
                              } else {
                                Get.toNamed(AppRoutes.login);
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rekomendasi Favorit Saya',
                        style: fprimMd,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.category,
                              arguments: 'recom=Rekomendasi untukmu');
                        },
                        child: Text(
                          'Semuanya',
                          style: fprimMd,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 280,
                  child: GetBuilder<MagazineController>(builder: (_) {
                    if (_.loading) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return const LoadingCardWidget();
                        },
                      );
                    }

                    if (_.listMagazine.isEmpty) {
                      return const BlankItem();
                    }

                    List<MagazineItem> takeIt = _.listMagazine.take(5).toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemCount: takeIt.length,
                      itemBuilder: (BuildContext context, int index) {
                        MagazineItem data = takeIt[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: MagazineCard(
                            item: data,
                            image: "${Endpoint.storage}/${data.cover}",
                            title: data.name,
                            release: data.dateRelease,
                            view: data.likes,
                            pressRead: () {
                              Get.toNamed(AppRoutes.detailMagazine,
                                  arguments: data);
                            },
                          ),
                        );
                      },
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CBottomNav(
        selectedItem: 3,
      ),
    );
  }
}

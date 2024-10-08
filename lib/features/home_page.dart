// ignore_for_file: deprecated_member_use

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/common/utils/session.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/blog/controller/blog_controller.dart';
import 'package:magazine/features/blog/model/news_model.dart';
import 'package:magazine/features/magazine/controller/dashboard_controller.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/view/widgets/magazine_card.dart';
import 'package:magazine/features/magazine/view/widgets/pdf_view_custom.dart';
import 'package:magazine/shared/global-widgets/background_widget.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/dialog_custom.dart';
import 'package:magazine/shared/global-widgets/drawer_custom.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';
import 'package:magazine/shared/global-widgets/custom_card.dart';
import 'package:magazine/shared/global-widgets/two_side_rounded_button.dart';
import 'package:magazine/shared/global-widgets/navbar_bottom.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:magazine/common/utils/app_format.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AuthController authController = Get.put(AuthController());
  final cMaga = Get.put(MagazineController());
  final cBlog = Get.put(BlogController());
  final cDashboard = Get.put(DashboardController());
  String? imgUrl;

  @override
  void initState() {
    refresh();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void refresh() {
    cMaga.getMagazine();
    cBlog.getNews();
    cDashboard.fetchVideoUrls();
    authController.profile();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      for (var controller in cDashboard.videoControllers) {
        controller.pauseVideo();
      }
    }
    super.didChangeAppLifecycleState(state);
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
          email: authController.dataUser.email,
          img: imgUrl,
          user: authController.dataUser,
        );
      }),
      body: ColorfulSafeArea(
        color: BaseColor.primary.withOpacity(0.6),
        child: RefreshIndicator.adaptive(
          color: BaseColor.primary,
          onRefresh: () async {
            setState(() {
              refresh();
            });
          },
          child: Stack(
            children: [
              const BackgroundWidget(),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * .03),
                    header(),
                    const SizedBox(height: 30),
                    // if (cMaga.isOffline) ...[
                    //   SizedBox(
                    //     height: size.height,
                    //     width: double.infinity,
                    //     child: ListView.builder(
                    //       itemCount: cMaga.dataCacheMagazine.length,
                    //       itemBuilder: (context, index) {
                    //         MagazineItem item =
                    //             cMaga.dataCacheMagazine[index];
                    //         return FavCard(
                    //             title: item.name,
                    //             onTap: () {},
                    //             onPressed: () {});
                    //       },
                    //     ),
                    //   )
                    // ] else ...[

                    // ]
                    banner(),
                    const SizedBox(height: 30),
                    newest(),
                    const SizedBox(height: 30),
                    popular(),
                    youtube(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          bestOfTheDayCard(size, context),
                          // RichText(
                          //   text: const TextSpan(
                          //     children: [
                          //       TextSpan(text: "Continue "),
                          //       TextSpan(
                          //         text: "reading...",
                          //         style: TextStyle(fontWeight: FontWeight.bold),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 30),
                          continueRead(size),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //
              Align(
                alignment: Alignment.topRight,
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 35, right: 20),
                    child: authController.tokenAccess.isEmpty
                        ? SizedBox(
                            width: 60,
                            child: ButtonCustom(
                                padding: 10,
                                borderRadius: 20,
                                onClick: () => Get.toNamed(AppRoutes.login),
                                text: 'Masuk'),
                          )
                        : Builder(builder: (ctx) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1.5,
                                        color: BaseColor.primary
                                            .withOpacity(0.6))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      Scaffold.of(ctx).openDrawer();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icons/menu.svg',
                                      color: BaseColor.primary,
                                      height: 23,
                                      width: 23,
                                    ),
                                  ),
                                ));
                          }),
                  );
                }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CBottomNav(
        selectedItem: 0,
      ),
    );
  }

  Widget youtube() {
    return GetBuilder<DashboardController>(builder: (_) {
      if (_.loading) {
        return const LoadingCardWidget();
      }

      if (_.videoControllers.isEmpty) {
        return const SizedBox();
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Video terbaru',
                  style: fprimMd,
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    DialogCustom.showConfirmationDialog(
                        'Jika video error',
                        'Gulir layar anda ke bawah, hingga muncul indikator loading 🔃',
                        () {},
                        true);
                  },
                  child: const Icon(
                    CupertinoIcons.question_circle,
                    color: BaseColor.primary,
                    size: 15,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                        '${AppRoutes.detailBlog}?url=https://www.youtube.com/@yatimmandirichannel');
                  },
                  child: Text(
                    'Tonton Semuanya',
                    style: fprimMd,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.22,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: false,
              padding: const EdgeInsets.only(left: 24),
              itemCount: _.videoControllers.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 280,
                          child: YoutubePlayer(
                            controller: _.videoControllers[index],
                            backgroundColor: Colors.transparent,
                            aspectRatio: 1.77,
                            enableFullScreenOnVerticalDrag: false,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () async {
                              await cDashboard.fetchVideoUrls();
                              // ignore: use_build_context_synchronously
                              _showVideoDialog(ctx, _.videoControllers[index]);
                            },
                            icon: const Icon(
                              CupertinoIcons.fullscreen,
                              color: Colors.transparent,
                            )),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  void _showVideoDialog(BuildContext ctx, YoutubePlayerController controller) {
    // ignore: unused_local_variable
    var currentOrientation = MediaQuery.of(context).orientation;

    // Change orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    showDialog(
      context: ctx,
      builder: (ctx) {
        return WillPopScope(
            onWillPop: () async {
              // Reset orientation to the original
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
              return true;
            },
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Material(
                      color: Colors.transparent,
                      child: CloseButton(
                        color: Colors.white,
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: YoutubePlayer(
                    controller: controller,
                    backgroundColor: Colors.transparent,
                    aspectRatio: 2,
                    enableFullScreenOnVerticalDrag: true,
                  ),
                ),
              ],
            ));
      },
    ).then((_) {
      // Reset orientation to the original
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
  }

  Column popular() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terpopular ${DateTime.now().year}',
                style: fprimMd,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.popular,
                      arguments: DateTime.now().year);
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

            List<MagazineItem> takeIt =
                _.getTopMagazinesByYear(DateTime.now().year, 5);

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
                      Get.toNamed(AppRoutes.detailMagazine, arguments: data);
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Column newest() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Terbaru',
                style: fprimMd,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.category, arguments: 'newest=Terbaru');
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

            _.listMagazine
                .sort((a, b) => b.dateRelease!.compareTo(a.dateRelease!));

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
                      Get.toNamed(AppRoutes.detailMagazine, arguments: data);
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  GetBuilder<BlogController> banner() {
    return GetBuilder<BlogController>(builder: (_) {
      if (_.loading) {
        return const LoadingBannerWidget();
      }

      if (_.listNews.isEmpty) {
        return const BlankItem();
      }

      List<NewsItem> takeIt = _.listNews.take(5).toList();

      return CarouselSlider.builder(
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1.5,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        itemCount: takeIt.length,
        itemBuilder: (context, index, realIndex) {
          NewsItem data = takeIt[index];
          return CustomCard(
              onTap: () {
                Get.toNamed('${AppRoutes.detailBlog}?url=${data.link}');
              },
              img: data.large,
              title: data.title,
              release: data.date,
              category: 'Berita Terkini');
        },
      );
    });
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    style: fLg.copyWith(fontSize: 26),
                    text: "Sudahkah anda \nmembaca "),
                TextSpan(text: "Hari ini?", style: fsecLg)
              ],
            ),
          ),
          const Spacer(),
          // Container(
          //   decoration: const BoxDecoration(
          //       color: Colors.white, shape: BoxShape.circle),
          //   child: InkWell(
          //     onTap: () {
          //       Get.toNamed(AppRoutes.notif);
          //       // authController.getout();
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.all(6),
          //       child: Icon(
          //         Icons.notifications,
          //         size: 27,
          //         color: BaseColor.primary,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(width: 15,),
        ],
      ),
    );
  }

  Widget continueRead(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terakhir dibaca',
          style: fprimMd,
        ),
        GetBuilder<MagazineController>(
          builder: (_) {
            if (_.listMagazine.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            List<MagazineItem> res = _.filteredMagazines;

            if (res.isEmpty) {
              return Center(
                  child: BlankItemWidget(
                title: '',
                button: ButtonCustom(
                    onClick: () {
                      Get.toNamed(AppRoutes.group);
                    },
                    text: 'Ayo mulai membaca'),
              ));
            }

            return SizedBox(
              height: res.length * 130,
              child: ListView.builder(
                itemCount: res.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  MagazineItem magazine = res[index];
                  int id = magazine.id ?? 0;
                  int lastPage = _.lastPages[id] ?? 0;
                  int totalPage = _.totalPages[id] ?? 0;
                  double progress = totalPage != 0 ? (lastPage / totalPage) : 0;

                  return Container(
                    height: 80,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 10),
                          blurRadius: 33,
                          color: const Color(0xFFD3D3D3).withOpacity(.84),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => PdfViewCustom(
                              magazineId: magazine.id,
                              path: '${Endpoint.storage}/${magazine.pdf}',
                            ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 20, top: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            magazine.name ?? '',
                                            style: fBlackMd,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "Halaman $lastPage dari $totalPage",
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    ExtendedImage.network(
                                      "${Endpoint.storage}/${magazine.cover}",
                                      fit: BoxFit.cover,
                                      handleLoadingProgress: true,
                                      width: 45,
                                      height: 55,
                                      loadStateChanged: (state) {
                                        if (state.extendedImageLoadState ==
                                            LoadState.failed) {
                                          return AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: Colors.grey[300],
                                                child: const Icon(Icons
                                                    .broken_image_outlined),
                                              ));
                                        }

                                        if (state.extendedImageLoadState ==
                                            LoadState.loading) {
                                          return const LoadingCustom(
                                              height: 55, width: 45);
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 5,
                              width: size.width * progress,
                              decoration: BoxDecoration(
                                color: BaseColor.secondary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget bestOfTheDayCard(Size size, BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 45),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Ada yang ", style: fsecLg),
                TextSpan(
                  text: "baru nih...",
                  style: fprimLg,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        GetBuilder<MagazineController>(builder: (_) {
          if (_.listMagazine.isEmpty) {
            return const SizedBox();
          }
          MagazineItem item = _.listMagazine.first;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: 245,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 230,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(10, 20),
                          blurRadius: 20,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 24,
                            top: 24,
                            right: size.width * .1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * .25),
                                child: Text(
                                  item.name ?? '',
                                  style: fLg,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  AppFormat.removeHtmlTags(item.description!),
                                  textAlign: TextAlign.justify,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: fsecMd.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            height: 40,
                            width: size.width * .3,
                            child: TwoSideRoundedButton(
                              text: "Baca",
                              radious: 24,
                              press: () {
                                Get.toNamed(AppRoutes.detailMagazine,
                                    arguments: item);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 0,
                  child: Container(
                    height: 100,
                    width: size.width * .21,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-5, 5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    child: ExtendedImage.network(
                      '${Endpoint.storage}/${item.cover}',
                      fit: BoxFit.cover,
                      handleLoadingProgress: true,
                      width: size.width * .21,
                      height: 100,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.failed) {
                          return AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Material(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image_outlined),
                              ));
                        }

                        if (state.extendedImageLoadState == LoadState.loading) {
                          return LoadingCustom(
                              height: 100, width: size.width * .21);
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

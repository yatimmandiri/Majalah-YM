import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/common/utils/app_format.dart';
import 'package:magazine/config/endpoints.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/comment_model.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/features/magazine/data/service/magazine_service.dart';
import 'package:magazine/features/magazine/view/widgets/magazine_card.dart';
import 'package:magazine/features/magazine/view/widgets/pdf_view_custom.dart';
import 'package:magazine/shared/global-widgets/blank_item.dart';
import 'package:magazine/shared/global-widgets/buttons.dart';
import 'package:magazine/shared/global-widgets/inputs.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailPage extends StatefulWidget {
  DetailPage({super.key, required this.item});

  final MagazineItem item;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // final MagazineItem item = Get.arguments;
  final cAuth = Get.put(AuthController());

  final cMagazine = Get.put(MagazineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            backgroundImage(),
            BackButtonCustom(
              padding: EdgeInsets.only(left: 18, top: 35),
              color: Colors.white,
            ),
            customShadow(),
            Column(
              children: [
                content(),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Terkait',
                        style: fprimMd,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.category,
                              arguments:
                                  'categories=${widget.item.relationship!.map((e) => e.id).join(',')}');
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
                    List<MagazineItem> relatedItems = _.listMagazine
                        .where((m) => m.relationship!.any((e) => widget
                            .item.relationship!
                            .any((item2) => item2.id == e.id)))
                        .toList()
                        .where((magazine) => magazine.id != widget.item.id)
                        .toList();

                    List<MagazineItem> result = relatedItems.take(5).toList();

                    if (result.isEmpty) {
                      return const BlankItem();
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemCount: result.length,
                      itemBuilder: (BuildContext context, int index) {
                        MagazineItem data = result[index];
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
                                  arguments: data, preventDuplicates: false);
                            },
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton.extended(
            backgroundColor: BaseColor.primary,
            onPressed: () async {
              if (widget.item.pdf!.isNotEmpty) {
                await MagazineService.fetchLike(widget.item.id ?? 0);

                Get.to(() => PdfViewCustom(
                      path: '${Endpoint.storage}/${widget.item.pdf}',
                      magazineId: widget.item.id,
                    ));
              }
            },
            icon: Icon(CupertinoIcons.book_fill, color: Colors.white,),
            label: Text(
              'Mulai membaca',
              style: fLg.copyWith(fontSize: 17, color: Colors.white),
            )),
      ),
    );
  }

  Widget backgroundImage() {
    return ExtendedImage.network(
      "${Endpoint.storage}/${widget.item.cover}",
      fit: BoxFit.cover,
      handleLoadingProgress: true,
      width: double.infinity,
      height: 390,
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
          return LoadingCustom(height: 390, width: double.infinity);
        }
        return null;
      },
    );
  }

  Widget customShadow() {
    return Container(
      height: 215,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 175),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.transparent,
            Colors.black,
          ])),
    );
  }

  Widget content() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 256),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name ?? '',
                        style: fLg.copyWith(color: Colors.white, height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppFormat.date2(
                            widget.item.dateRelease ?? '--/--/----'),
                        style: fMd.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${AppFormat.formatThousand((widget.item.likes ?? 0).toInt()).toString()} reads',
                        style: fSm.copyWith(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  bool exists = cMagazine.dataCacheMagazine
                      .any((data) => data.id == widget.item.id);

                  return IconButton(
                    onPressed: () {
                      if (cAuth.isAuthenticated) {
                        cMagazine
                            .addOrRemoveMagazine(widget.item)
                            .then((value) {
                          if (value) {
                            cMagazine.loadMagazineFav();
                          }
                        });
                      } else {
                        Get.toNamed(AppRoutes.login);
                      }
                    },
                    icon: Icon(
                      exists
                          ? Icons.bookmark_outlined
                          : Icons.bookmark_border_rounded,
                      color: exists ? BaseColor.primary : Colors.white,
                    ),
                  );
                }),
              ],
            ),
          ),
          // NOTE: DESCRIPTION
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE: ABOUT
                Text(
                  'Tentang',
                  style: fBlackMd.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 6,
                ),
                Obx(() {
                  return Column(
                    children: [
                      Text(
                          cMagazine.isExpanded.value
                              ? AppFormat.removeHtmlTags(
                                  widget.item.description!)
                              : (widget.item.description!.length > 250
                                  ? AppFormat.removeHtmlTags(widget
                                          .item.description!
                                          .substring(0, 250)) +
                                      '...'
                                  : AppFormat.removeHtmlTags(
                                      widget.item.description!)),
                          textAlign: TextAlign.justify,
                          style:
                              fBlackMd.copyWith(fontWeight: FontWeight.w300)),
                      TextButton(
                        onPressed: cMagazine.toggleExpanded,
                        child: Text(cMagazine.isExpanded.value
                            ? 'Tampilkan sedikit'
                            : 'Tampilkan semua'),
                      ),
                    ],
                  );
                }),

                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Kategori',
                  style: fBlackMd.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    widget.item.relationship!.map((e) => e.name).join(', '),
                    style: fMd.copyWith(fontSize: 10, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reviewers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Komentar',
          style: fBlackMd.copyWith(fontWeight: FontWeight.w800),
        ),
        GetBuilder<MagazineController>(
          builder: (_) {
            final magazine = _.getMagazineById(widget.item.id!);

            if (magazine == null) {
              return LoadingCustom();
            }

            List<CommentItem> takeIt = (magazine.comments
                    ?.where((comment) => comment.parentId == 0)
                    .toList()
                    .reversed
                    .toList()
                    .take(3)
                    .toList()) ??
                [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: takeIt.length > 1
                      ? 85 * 2
                      : 75 * takeIt.length.toDouble(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: takeIt.length,
                    itemBuilder: (context, index) {
                      CommentItem comment = takeIt[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/200'),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.username!.isNotEmpty
                                      ? comment.username != cAuth.dataUser.name
                                          ? comment.username.toString()
                                          : 'Anda'
                                      : '@user',
                                  style: fBlackSm.copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  comment.content ?? '',
                                  textAlign: TextAlign.justify,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('h:mm, d MMM yyyy').format(
                                  DateTime.parse(
                                      comment.createdAt ?? '12-12-2000')),
                              textAlign: TextAlign.justify,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (magazine.comments!.isNotEmpty) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.comment, arguments: widget.item);
                    },
                    child: Text(
                      'Tampilkan semua ${AppFormat.formatThousand(magazine.comments!.length)} komentar',
                      style: fMd.copyWith(color: BaseColor.secondary),
                    ),
                  ),
                ],
                if (cAuth.isAuthenticated) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                            child: InputForm(
                          hintText: 'type...',
                          controller: _.controllerComment,
                          radius: 20,
                        )),
                        if (_.loadButton) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: BaseColor.primary,
                            ),
                          )
                        ] else ...[
                          Container(
                            margin: const EdgeInsets.only(left: 3),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: BaseColor.secondary,
                                borderRadius: BorderRadius.circular(35)),
                            child: InkWell(
                              onTap: () {
                                if (_.controllerComment.text.isNotEmpty) {
                                  _.sendComment(widget.item.id!,
                                      content: _.controllerComment.text);
                                  _.controllerComment.clear();
                                } else {
                                  Fluttertoast.showToast(
                                      backgroundColor: Colors.red,
                                      msg: "isi kolom komentar anda");
                                }
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ],
                    );
                  }),
                ] else ...[
                  if (!magazine.comments!.isNotEmpty) ...[
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.login, arguments: widget.item);
                      },
                      child: Text(
                        'Login dulu',
                        style: fMd.copyWith(color: BaseColor.secondary),
                      ),
                    ),
                  ]
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

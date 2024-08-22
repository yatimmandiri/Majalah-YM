import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/common/utils/app_format.dart';
import 'package:magazine/features/auth/controller/auth_controller.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:magazine/features/magazine/data/model/magazine_model.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';
import 'package:magazine/shared/global-widgets/two_side_rounded_button.dart';

class MagazineCard extends StatelessWidget {
  final String? image;
  final String? title;
  final String? release;
  final int? view;
  final MagazineItem item;
  final Function()? pressRead;

  const MagazineCard({
    super.key,
    this.image,
    this.title,
    this.release,
    this.pressRead,
    required this.item,
    this.view,
  });

  @override
  Widget build(BuildContext context) {
    final cMagazine = Get.put(MagazineController());
    final cAuth = Get.put(AuthController());
    bool exists = cMagazine.dataCacheMagazine.any((data) => data.id == item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      height: 245,
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29),
        boxShadow: const [
          BoxShadow(
            offset: Offset(5, 10),
            blurRadius: 20,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(29),
                    topRight: Radius.circular(29)),
                child: ExtendedImage.network(
                  image ?? '',
                  fit: BoxFit.cover,
                  handleLoadingProgress: true,
                  width: double.infinity,
                  height: 245 * .5,
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
                          height: 245 * .5, width: double.infinity);
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (cAuth.isAuthenticated) {
                    cMagazine.addOrRemoveMagazine(item).then((value) {
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
              ),
            ],
          ),
          GestureDetector(
            onTap: pressRead,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '-',
                    style: fBlackMd,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Text(
                        AppFormat.date2(release ?? '--/--/----'),
                        style: fSm.copyWith(color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        AppFormat.formatThousand((view ?? 0).toInt())
                            .toString(),
                        style: fSm.copyWith(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        'dibaca',
                        style: fSm.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: TwoSideRoundedButton(
                  text: "Baca",
                  press: pressRead,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

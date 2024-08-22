import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      this.img,
      this.title,
      this.release,
      this.category,
      this.onTap});

  final String? img;
  final String? title;
  final String? release;
  final String? category;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExtendedImage.network(
            img ?? '',
            fit: BoxFit.cover,
            handleLoadingProgress: true,
            width: size.width,
            height: size.height,
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
                return LoadingCustom(height: size.height, width: size.width);
              }
              return null;
            },
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size.width,
            height: 100,
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '-',
                        style: fMd.copyWith(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.date_range_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            release ?? '--/--/----',
                            style: fSm.copyWith(color: Colors.white),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.api,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                category ?? '',
                                style: fSm.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

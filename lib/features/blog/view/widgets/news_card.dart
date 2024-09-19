import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class NewsCard extends StatelessWidget {
  const NewsCard(
      {super.key,
      this.img,
      this.title,
      this.release,
      this.onTap,
      this.width,
      this.height});

  final String? img;
  final String? title;
  final String? release;
  final double? width;
  final double? height;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ExtendedImage.network(
              img ?? '',
              fit: BoxFit.cover,
              handleLoadingProgress: true,
              width: width,
              height: height,
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
                  return const LoadingBannerWidget();
                }
                return null;
              },
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: width,
              height: height,
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Colors.transparent,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          title ?? '-',
                          style: fMd.copyWith(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
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
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

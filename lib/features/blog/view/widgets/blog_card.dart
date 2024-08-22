import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/utils/app_format.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class BlogCard extends StatelessWidget {
  final String? image;
  final String? title;
  final String? release;
  final void Function()? pressRead;

  const BlogCard({
    super.key,
    this.image,
    this.title,
    this.release,
    this.pressRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              offset: Offset(5, 10),
              blurRadius: 10,
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: pressRead,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child:
                        ExtendedImage.network(
                      image ?? 'https://via.placeholder.com/200',
                      fit: BoxFit.cover,
                      handleLoadingProgress: true,
                      width: 80,
                      height: 80,
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
                          return LoadingCustom(height: 80, width: 80);
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? '',
                          style: fBlackMd,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppFormat.date2(release!),
                          style: fBlackSm,
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
    );
  }
}

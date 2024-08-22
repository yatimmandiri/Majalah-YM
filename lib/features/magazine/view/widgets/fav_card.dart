import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/shared/global-widgets/loading_widget.dart';

class FavCard extends StatelessWidget {
  const FavCard(
      {super.key,
      this.img,
      this.title,
      required this.onTap,
      required this.onPressed});

  final String? img;
  final String? title;
  final void Function() onTap;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 15),
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
            onTap: () => onTap(),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ExtendedImage.network(
                    img ?? '',
                    fit: BoxFit.cover,
                    handleLoadingProgress: true,
                    width: 60,
                    height: 60,
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
                        return LoadingCustom(height: 60, width: 60);
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    title ?? '',
                    style: fBlackMd,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
              onPressed: () => onPressed(),
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}

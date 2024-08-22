import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';

class NotifCard extends StatelessWidget {
  final String? image;
  final String? title;
  final void Function()? pressRead;

  const NotifCard({
    super.key,
    this.image,
    this.title,
    this.pressRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: pressRead,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/blank.png',
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      )),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Badge(
                        largeSize: 17,
                        backgroundColor: Colors.lightBlue,
                        label: Text('New', style: fSm.copyWith(color: Colors.white),),
                      ),
                      SizedBox(
                        height: 5,
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

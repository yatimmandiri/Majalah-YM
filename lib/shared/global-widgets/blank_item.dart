import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';

class BlankItem extends StatelessWidget {
  const BlankItem({super.key, this.img, this.title});

  final String? img;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 3,
              child: Image.asset(img ?? 'assets/images/blank.png')),
          const SizedBox(
            height: 10,
          ),
          Text(
            title ?? 'Data Kosong',
            style: fBlackLg,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class BlankItemWidget extends StatelessWidget {
  const BlankItemWidget({super.key, this.button, this.title});

  final String? title;
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            title ?? 'Data Kosong',
            style: fBlackLg,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          button ?? SizedBox()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:magazine/common/theme/color.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {

    double getSmallDiameter(BuildContext context) =>
        MediaQuery.of(context).size.width * 1 / 2;

    double getBigDiameter(BuildContext context) =>
        MediaQuery.of(context).size.width * 10 / 8;

    return Stack(
      children: [
        Positioned(
          left: -getBigDiameter(context) / 6,
          top: -getBigDiameter(context) / 1.6,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration: BoxDecoration(
              color: BaseColor.primary.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Positioned(
        //   right: -getBigDiameter(context) / 3,
        //   top: -getBigDiameter(context) / 3,
        //   child: Container(
        //     width: getBigDiameter(context),
        //     height: getBigDiameter(context),
        //     decoration: BoxDecoration(
        //       color: BaseColor.primary.withOpacity(0.2),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
        // Positioned(
        //   left: -getSmallDiameter(context) / 1.6,
        //   top: getSmallDiameter(context) / 2.4,
        //   child: Container(
        //     width: getSmallDiameter(context),
        //     height: getSmallDiameter(context),
        //     decoration: BoxDecoration(
        //       color: BaseColor.primary.withOpacity(0.3),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
        // Positioned(
        //   left: getSmallDiameter(context) / 5,
        //   top: getSmallDiameter(context) / 1.6,
        //   child: Container(
        //     width: getSmallDiameter(context),
        //     height: getSmallDiameter(context),
        //     decoration: BoxDecoration(
        //       color: BaseColor.primary.withOpacity(0.3),
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
        Positioned(
          left: -getBigDiameter(context) / 3,
          bottom: -getBigDiameter(context) / 1.4,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: BaseColor.secondary.withOpacity(0.5),
            ),
          ),
        ),
        // Positioned(
        //   right: -getSmallDiameter(context) / 3,
        //   bottom: -getSmallDiameter(context) / 2,
        //   child: Container(
        //     width: getSmallDiameter(context),
        //     height: getSmallDiameter(context),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: BaseColor.primary.withOpacity(0.7),
        //     ),
        //   ),
        // ),
        Positioned(
          right: -getBigDiameter(context) / 3,
          bottom: -getBigDiameter(context) / 1.2,
          child: Container(
            width: getBigDiameter(context),
            height: getBigDiameter(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: BaseColor.secondary.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

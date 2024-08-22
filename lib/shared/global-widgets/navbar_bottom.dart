// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:magazine/common/app_route.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';

class CBottomNav extends StatefulWidget {
  const CBottomNav({super.key, this.selectedItem = 0});

  final int selectedItem;

  @override
  State<CBottomNav> createState() => _CBottomNavState();
}

class _CBottomNavState extends State<CBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff3E424D).withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 19,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomNavItem(
            selectedMenu: widget.selectedItem == 0,
            title: 'Home',
            icon: 'assets/icons/bottomnav-1.svg',
            page: AppRoutes.home,
          ),
          BottomNavItem(
            selectedMenu: widget.selectedItem == 1,
            title: 'Kumpulan',
            icon: 'assets/icons/bottomnav-2.svg',
            page: AppRoutes.group,
          ),
          BottomNavItem(
            selectedMenu: widget.selectedItem == 2,
            title: 'Literasi',
            icon: 'assets/icons/bottomnav-3.svg',
            page: AppRoutes.blog,
          ),
          BottomNavItem(
            selectedMenu: widget.selectedItem == 3,
            title: 'Favorit',
            icon: 'assets/icons/bottomnav-4.svg',
            page: AppRoutes.favMagazine,
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.selectedMenu,
    required this.title,
    required this.icon,
    required this.page,
  });

  final bool selectedMenu;
  final String title;
  final String icon;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed(page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              height: 21,
              color: selectedMenu ? BaseColor.secondary : const Color(0xffA0A0A0),
            ),
            Text(
              title,
              style: fsecMd.copyWith(
                  color: selectedMenu
                      ? BaseColor.secondary
                      : const Color(0xffA0A0A0)),
            )
          ],
        ),
      ),
    );
  }
}

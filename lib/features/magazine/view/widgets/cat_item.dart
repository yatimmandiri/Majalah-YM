import 'package:flutter/material.dart';

import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';

class CatItem extends StatefulWidget {
  const CatItem({
    super.key,
    this.id,
    this.title,
    required this.categories,
    required this.onToggle,
    this.marginR,
  });

  final int? id;
  final double? marginR;
  final String? title;
  final List<int> categories;
  final ValueChanged<int> onToggle;

  @override
  State<CatItem> createState() => _CatItemState();
}

class _CatItemState extends State<CatItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onToggle(widget.id ?? 0);
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.only(right: widget.marginR ?? 5),
        decoration: BoxDecoration(
          color: isSelected ? BaseColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? Colors.white : BaseColor.primary, width: 1),
        ),
        child: Text(
          widget.title ?? '',
          style: fMd.copyWith(
              color: isSelected ? Colors.white : BaseColor.primary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

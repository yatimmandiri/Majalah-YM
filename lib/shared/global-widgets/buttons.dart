import 'package:flutter/material.dart';
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom(
      {super.key,
      this.backgroundColor,
      this.onClick,
      required this.text,
      this.decoration,
      this.fontSize = 14,
      this.padding = 13,
      this.prefix,
      this.visible = false,
      this.textColor = Colors.white,
      this.borderRadius,
      this.paddingHor = 0,
      this.suffix});

  final Color? backgroundColor;
  final String text;
  final void Function()? onClick;
  final BoxDecoration? decoration;
  final double fontSize, padding, paddingHor;
  final Widget? prefix, suffix;
  final bool? visible;
  final Color? textColor;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 800),
        child: Material(
          color: backgroundColor ?? BaseColor.secondary,
          child: InkWell(
            onTap: onClick,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: padding, horizontal: paddingHor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                      visible: visible!, child: prefix ?? const SizedBox()),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: fMd.copyWith(color: textColor, fontSize: fontSize),
                  ),
                  Visibility(
                      visible: visible!, child: suffix ?? const SizedBox()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key, this.padding, this.color});

  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: BackButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color)),
      ),
    );
  }
}

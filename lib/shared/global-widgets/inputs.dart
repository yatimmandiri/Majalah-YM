import 'package:flutter/material.dart';
import 'package:magazine/common/theme/color.dart';

class InputForm extends StatefulWidget {
  const InputForm({
    super.key,
    this.controller,
    this.keyboardType,
    required this.hintText,
    this.label,
    this.obscureText = false,
    this.onChange,
    this.onTap,
    this.prefixIcon,
    this.readOnly = false,
    this.fillColor,
    this.suffixIcon,
    this.radius,
    this.sideColor,
    this.maxLines,
    this.focusNode,
    this.validate,
  });
  final String hintText;
  final Widget? label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onChange;
  final void Function()? onTap;
  final bool obscureText;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Color? sideColor;
  final double? radius;
  final int? maxLines;
  final String? validate;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly ?? false,
      onChanged: widget.onChange,
      controller: widget.controller,
      obscureText: widget.obscureText,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscuringCharacter: '\u25CF',
      onTap: widget.onTap,
      style: const TextStyle(
        fontSize: 12,
        height: 0,
        fontWeight: FontWeight.w400,
      ),
      validator: (value) => value == '' ? "Jangan Kosong" : null,
      maxLines: widget.maxLines ?? 1,
      decoration: InputDecoration(
        label: widget.label ?? null,
        prefixIcon: widget.prefixIcon ??
            const SizedBox(
              width: 15,
            ),
        suffixIcon: widget.suffixIcon ??
            const SizedBox(
              width: 15,
            ),
        prefixIconConstraints: const BoxConstraints(),
        filled: true,
        fillColor: widget.fillColor ?? const Color(0xffffffff),
        hintText: widget.hintText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        isDense: true,
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 0,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.sideColor ?? Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.radius ?? 10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.sideColor ?? Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.radius ?? 10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: BaseColor.primary),
          borderRadius: BorderRadius.all(
            Radius.circular(widget.radius ?? 10),
          ),
        ),
      ),
    );
  }
}

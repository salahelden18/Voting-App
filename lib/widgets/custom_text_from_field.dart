import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String text;
  final String? Function(String?)? validator;
  final void Function(String?)? save;
  final bool isPassword;
  final TextInputType? textInputType;
  final int maxLines;
  final Widget? prefixIcon;

  const CustomTextFormField({
    Key? key,
    required this.text,
    required this.validator,
    required this.save,
    this.prefixIcon,
    this.maxLines = 1,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: text,
        hintStyle: Theme.of(context).textTheme.headline6,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        filled: true,
        fillColor: const Color(0xffECEDF1),
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: forthColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      style: Theme.of(context).textTheme.headline6,
      validator: validator,
      onSaved: save,
      keyboardType: textInputType,
      maxLines: maxLines,
      obscureText: isPassword,
    );
  }
}

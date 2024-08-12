import 'package:flutter/material.dart';
import 'package:echo_lens/Widgets/colors_global.dart';

class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    required this.obscure,
    this.readonly = false,
    this.ontap,
  });

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final bool readonly;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(
        top: 3,
        left: 15,
      ),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.mainColor.withOpacity(0.19),
              blurRadius: 10,
            )
          ]),
      child: TextFormField(
        readOnly: readonly,
        onTap: ontap,
        controller: controller,
        keyboardType: textInputType,
        obscureText: obscure,
        cursorColor: GlobalColors.mainColor,
        decoration: InputDecoration(
            hintText: text,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            hintStyle: TextStyle(
              height: 1,
              color: Colors.grey.shade700,
            )),
        style: TextStyle(
          color: GlobalColors.textColor,
        ),
      ),
    );
  }
}

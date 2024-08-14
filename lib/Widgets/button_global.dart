import 'package:flutter/material.dart';
import 'package:echo_lens/Widgets/colors_global.dart';

class ButtonGlobal extends StatelessWidget {
  const ButtonGlobal({
    super.key,
    required this.buttontext,
    this.pageRoute,
    this.onPressed,
  });

  final String buttontext;
  final Widget? pageRoute;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (pageRoute != null && onPressed != null) {
          onPressed!();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => pageRoute!),
          );
        } else if (onPressed != null) {
          onPressed!();
        } else if (pageRoute != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => pageRoute!),
          );
        }
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          buttontext,
          style: TextStyle(
            color: GlobalColors.themeColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

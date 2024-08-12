import 'package:flutter/material.dart';
import 'package:echo_lens/Widgets/colors_global.dart';

class ButtonGlobal extends StatelessWidget {
  const ButtonGlobal({super.key, required this.buttontext, this.pageRoute , this.onPressed,});

  final String buttontext;
  final Widget? pageRoute;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if (pageRoute != null && onPressed != null ) {
          onPressed!();
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> pageRoute!),);
        } else if (onPressed != null) {
          onPressed!();
        } else if ( pageRoute!= null){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> pageRoute!),);
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: GlobalColors.mainColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: GlobalColors.mainColor.withOpacity(0.25),
              blurRadius: 10
            )
          ]
        ),
        child: Text(buttontext,
        style: TextStyle(
          color: GlobalColors.themeColor,
          fontWeight: FontWeight.w800,
        ),),
      ),
    );
  }
}
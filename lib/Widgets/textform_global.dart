import 'package:flutter/material.dart';
import 'package:echo_lens/Widgets/colors_global.dart';

class TextFormGlobal extends StatefulWidget {
  const TextFormGlobal({
    super.key,
    required this.controller,
    required this.text,
    required this.textInputType,
    this.readonly = false,
    this.password = false,
    this.ontap,
  });

  final TextEditingController controller;
  final String text;
  final TextInputType textInputType;
  final bool readonly;
  final bool password;
  final VoidCallback? ontap;

  @override
  State<TextFormGlobal> createState() => _TextFormGlobalState();
}

class _TextFormGlobalState extends State<TextFormGlobal> {
  late bool isObsecurePass;

  @override
  void initState() {
    super.initState();
    if (widget.password) {
      isObsecurePass = true;
    } else {
      isObsecurePass = false;
    }
  }

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
        border: Border.all(
          color: GlobalColors.mainColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        readOnly: widget.readonly,
        onTap: widget.ontap,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        obscureText: isObsecurePass,
        cursorColor: GlobalColors.mainColor,
        decoration: InputDecoration(
          hintText: widget.text,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: TextStyle(
            height: 1,
            color: Colors.grey.shade700,
          ),
          suffixIcon: widget.password
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecurePass = !isObsecurePass;
                    });
                  },
                  icon: Icon(
                    isObsecurePass ? Icons.visibility_off : Icons.visibility,
                    color: GlobalColors.mainColor,
                  ),
                )
              : null,
        ),
        style: TextStyle(
          color: GlobalColors.textColor,
        ),
      ),
    );
  }
}

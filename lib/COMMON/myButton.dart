import 'package:flutter/material.dart';
import 'package:yardimfeneri/extantion/size_extension.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final Color butonColor;
  final Color textColor;
  final double width;
  final double height;

   const MyButton(
      {Key key,
        this.text,
        this.butonColor : const Color(0xfff7cb15),
        this.onPressed,
        this.textColor,
        this.fontSize,
        this.width,
        this.height,
      })
      : assert(text != null ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: RaisedButton(
        color: butonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(65.7.w),
        ),
        onPressed: onPressed,
        elevation: 8.3,
        child: Text(
          this.text,
          style: TextStyle(
              color: textColor ?? Colors.black,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans",
              fontStyle: FontStyle.normal,
              fontSize: fontSize ?? 14.0),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:munch/theme/palette.dart';

class CustomFormField extends StatelessWidget{
  String hintText;
  String initialValue;
  TextStyle hintStyle;
  TextStyle textStyle;
  Function validator;
  Function onSaved;
  TextCapitalization textCapitalization;
  TextEditingController controller;
  Function onChanged;
  Color fillColor;
  double borderRadius;
  Color borderColor;

  CustomFormField({this.hintText, this.initialValue, this.textStyle,
    this.hintStyle, this.validator, this.onSaved, this.textCapitalization,
    this.controller, this.onChanged, this.fillColor, this.borderColor = Palette.secondaryLight, this.borderRadius = 4.0});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        isDense: true,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:borderColor), borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        errorMaxLines: 3,
        filled: true,
        fillColor: fillColor ?? Colors.transparent
      ),
      style: textStyle,
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller ,
      onChanged: onChanged,
      cursorColor: Palette.secondaryDark,
    );
  }

}
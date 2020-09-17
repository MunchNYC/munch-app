import 'package:flutter/material.dart';
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

  CustomFormField({this.hintText, this.initialValue, this.textStyle,
    this.hintStyle, this.validator, this.onSaved, this.textCapitalization,
    this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        isDense: true,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Palette.secondaryLight)),
        border: OutlineInputBorder(borderSide: BorderSide(color: Palette.secondaryLight)),
        errorMaxLines: 3
      ),
      style: textStyle,
      validator: validator,
      onSaved: onSaved,
      initialValue: initialValue,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller ,
      onChanged: onChanged,
    );
  }

}
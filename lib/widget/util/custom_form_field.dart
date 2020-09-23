import 'package:flutter/material.dart';
import 'package:munch/theme/palette.dart';

class CustomFormField extends StatelessWidget{
  String hintText;
  String initialValue;
  TextStyle hintStyle;
  TextStyle textStyle;
  Function validator;
  Function onSaved;
  Function onTap;
  TextCapitalization textCapitalization;
  TextEditingController controller;
  Function onChanged;
  Color fillColor;
  double borderRadius;
  Color borderColor;
  bool readOnly;
  FocusNode focusNode;
  String labelText;
  TextStyle labelStyle;
  EdgeInsets contentPadding;
  int maxLines;
  bool errorHasBorders;

  CustomFormField({this.hintText, this.initialValue, this.textStyle,
    this.hintStyle, this.validator, this.onSaved, this.onTap, this.textCapitalization,
    this.controller, this.onChanged, this.fillColor,
    this.borderColor = Palette.secondaryLight, this.borderRadius = 4.0, this.readOnly = false,
    this.focusNode, this.labelText, this.labelStyle, this.contentPadding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
    this.maxLines = 1, this.errorHasBorders = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText, //labelStyle.copyWith(height: -12.0),
        hintText: hintText,
        hintStyle: hintStyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: contentPadding,
        isDense: true,
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:borderColor), borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        errorBorder: errorHasBorders ?
            OutlineInputBorder(borderSide: BorderSide(color:Palette.error), borderRadius: BorderRadius.all(Radius.circular(borderRadius)))
          : InputBorder.none,
        focusedErrorBorder: errorHasBorders ?
            OutlineInputBorder(borderSide: BorderSide(color:Palette.error), borderRadius: BorderRadius.all(Radius.circular(borderRadius)))
          : InputBorder.none,
          errorMaxLines: 3,
        filled: true,
        fillColor: fillColor ?? Colors.transparent
      ),
      style: textStyle,
      validator: validator,
      onSaved: onSaved,
      onTap: onTap,
      initialValue: initialValue,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller ,
      onChanged: onChanged,
      cursorColor: Palette.secondaryDark,
      readOnly: readOnly,
      focusNode: focusNode,
      maxLines: maxLines,
    );
  }

}
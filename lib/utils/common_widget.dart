import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget CommonTextInputWithTitle(
    {
      String title="",
      bool isValidationRequired = true,
      int? maxLength,
      int? minLength,
      int? length,
      hint = "",
      labeltext = "Enter Value",
      FontWeight lableFontStyle=FontWeight.normal,
      double lableFontSize=12,
      lableTextColor,
      TextEditingController? inputController,
      TextInputType textInputType = TextInputType.text,
      String? regexp,
      errortext,
      bool isRequired = false,
      bool isReadOnly = false,
      int  minLines =1,
      int maxLines =50,
      TextInputAction textInputAction = TextInputAction.done}) {


  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLines),// for mobile
      if(textInputType == TextInputType.number)...[
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
        FilteringTextInputFormatter.deny('+91'),
      ]
    ],
    minLines: 1,
    maxLines: maxLines,
    textInputAction: textInputAction,
    readOnly: isReadOnly,
    keyboardType: textInputType,
    controller: inputController,
    style: TextStyle(color: Colors.black),
    cursorColor: Colors.white,
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5), width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
              width: 1, color: Colors.grey.withOpacity(0.5)),
        ),
        fillColor: Colors.white,
        focusColor: Colors.white,
        border: OutlineInputBorder(),
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.grey
        )

    ),
    validator: (value) {
      if (value.toString().isEmpty) {
        if (isValidationRequired) {
          return 'Field required';
        } else if (value.toString().isNotEmpty && isRequired) {
          if (RegExp(regexp!).hasMatch(value.toString())) {
            return null;
          } else {
            return errortext;
          }
        } else {
          return null;
        }
      }
      return null;
    },
  );

}


import 'package:flutter/material.dart';

class TextStyling {
  bool darkMode;
  TextStyling(this.darkMode);
  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static final regularTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
      fontSize: 9.0,
      fontWeight: FontWeight.w400);
  static final subHeaderTextStyle =
      regularTextStyle.copyWith(fontSize: 12.0, fontFamily: 'Montserrat');
  static final headerTextStyle = baseTextStyle.copyWith(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.w600);
}

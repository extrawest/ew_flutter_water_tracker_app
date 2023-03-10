import 'package:flutter/material.dart';
import 'package:water_tracker/theme/theme.dart';

List<BoxShadow> get commonShadow {
  return [
    const BoxShadow(
        color: greyLight, offset: Offset(0, 2), blurRadius: 1, spreadRadius: 0),
    const BoxShadow(
        color: greyLight, offset: Offset(0, 4), blurRadius: 3, spreadRadius: 0),
    const BoxShadow(
        color: greyLight, offset: Offset(0, 8), blurRadius: 5, spreadRadius: 0),
  ];
}

List<ButtonStyle> get textButtonStyle {
  return [
    TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      padding: const EdgeInsets.all(20),
      primary: Colors.white,
      backgroundColor: darkIndgigo,
    ),
    ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0))),
    ),
  ];
}

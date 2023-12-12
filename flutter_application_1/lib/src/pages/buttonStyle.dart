import 'package:flutter/material.dart';

ButtonStyle styleButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF146001)),
  shape: MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7.0),
    ),
  ),
);

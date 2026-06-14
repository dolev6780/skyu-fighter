import 'package:flutter/material.dart';
import 'af_tokens.dart';

class AFText {
  static const String fontFamilyHeader = 'ChakraPetch';
  static const String fontFamilyBody = 'ShareTechMono';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilyHeader,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    color: Colors.white,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilyHeader,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: Colors.white,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamilyHeader,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 2,
    color: AF.cyan,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamilyBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
}

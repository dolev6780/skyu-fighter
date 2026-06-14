import 'package:flutter/material.dart';

class AF {
  // Surfaces
  static const Color bg = Color(0xFF001133);
  static const Color surface = Color(0xFF051020);
  static const Color border = Color(0xFF102540);
  
  // HUD cyan / action orange
  static const Color cyan = Color(0xFF00EEFF);
  static const Color blue = Color(0xFF0088FF);
  static const Color orange = Color(0xFFFF8800);
  static const Color orangeHot = Color(0xFFFF4400);
  
  // Semantic
  static const Color danger = Color(0xFFFF3333);
  static const Color success = Color(0xFF00EE55);
  static const Color gold = Color(0xFFFFD700);
  
  // Worlds
  static const Color worldDawn = Color(0xFFFFAA00);
  static const Color worldNight = Color(0xFF9933FF);
  
  // Radii / spacing
  static const double rControl = 12.0;
  static const double rModal = 24.0;
  static const double rPill = 32.0;
  
  static const double s4 = 12.0;
  static const double s5 = 16.0;
  static const double s7 = 24.0;
}

const actionGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFFFF8800), Color(0xFFFF4400)],
);

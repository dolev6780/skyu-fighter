// AeroFighter — typography as Flutter TextStyles.
// Structural text is UPPERCASE + widely tracked (set the string to .toUpperCase()).
// Telemetry (score, currency) uses ShareTechMono.
// Requires the ChakraPetch + ShareTechMono fonts declared in pubspec.yaml.
import 'package:flutter/material.dart';
import 'af_tokens.dart';

const _display = 'ChakraPetch';
const _ui = 'ChakraPetch';
const _mono = 'ShareTechMono';

class AFType {
  AFType._();

  // ── Display / HUD titles (use .toUpperCase()) ──
  static const hero = TextStyle(fontFamily: _display, fontSize: 34, height: 1.1,
      fontWeight: FontWeight.w700, letterSpacing: 4, color: AF.text);
  static const display = TextStyle(fontFamily: _display, fontSize: 28,
      fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, letterSpacing: 2, color: AF.text);
  static const title = TextStyle(fontFamily: _display, fontSize: 22,
      fontWeight: FontWeight.w700, letterSpacing: 3, color: AF.cyan);
  static const h1 = TextStyle(fontFamily: _display, fontSize: 18,
      fontWeight: FontWeight.w700, letterSpacing: 2, color: AF.text);
  static const h2 = TextStyle(fontFamily: _display, fontSize: 15,
      fontWeight: FontWeight.w700, letterSpacing: 2, color: AF.cyan);

  // ── Labels & body ──
  static TextStyle get label => TextStyle(fontFamily: _ui, fontSize: 11,
      fontWeight: FontWeight.w700, letterSpacing: 2, color: AF.cyanMid);
  static TextStyle get caption => TextStyle(fontFamily: _ui, fontSize: 10,
      fontWeight: FontWeight.w600, letterSpacing: 1, color: AF.textMuted);
  static TextStyle get body => TextStyle(fontFamily: _ui, fontSize: 13,
      height: 1.4, fontWeight: FontWeight.w400, color: AF.textDim);

  // ── Telemetry (mono) ──
  static const score = TextStyle(fontFamily: _mono, fontSize: 22, letterSpacing: 2, color: AF.blueSoft);
  static const best  = TextStyle(fontFamily: _mono, fontSize: 18, letterSpacing: 2, color: AF.gold);
  static const currency = TextStyle(fontFamily: _mono, fontSize: 16, letterSpacing: 1, color: AF.text);
  static const levelId  = TextStyle(fontFamily: _mono, fontSize: 13, letterSpacing: 1, color: AF.worldDawn);
}

// Helper: zero-pad a score like the HUD (000000).
String afPadScore(int n, [int width = 6]) => n.toString().padLeft(width, '0');

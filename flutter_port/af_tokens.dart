// AeroFighter — design tokens for Flutter/Flame.
// Generated from the AeroFighter Design System (tokens/*.css).
// Drop in lib/theme/ and reference AF.* everywhere instead of inline colors.
import 'dart:ui';
import 'package:flutter/material.dart';

class AF {
  AF._();

  // ── Surfaces (deep-navy cockpit chrome) ──
  static const void_   = Color(0xFF000A1A);
  static const bg      = Color(0xFF001133); // game background
  static const surface = Color(0xFF051020); // panel / card fill
  static const surface2 = Color(0xFF07182E);
  static const border  = Color(0xFF102540);
  static const borderQuiet = Color(0xFF002244);
  static const borderInactive = Color(0xFF003366);

  // ── HUD cyan (the signal color) ──
  static const cyan     = Color(0xFF00EEFF);
  static const cyanMid  = Color(0xFF00AAFF);
  static const blue     = Color(0xFF0088FF);
  static const blueSoft = Color(0xFF88CCFF);
  static const shield   = Color(0xFF4499FF);

  // ── Action orange ──
  static const orange     = Color(0xFFFF8800);
  static const orangeDeep = Color(0xFFFF5500);
  static const orangeHot  = Color(0xFFFF4400);
  static const amber      = Color(0xFFFF6600);

  // ── Semantic ──
  static const danger   = Color(0xFFFF3333);
  static const dangerHot = Color(0xFFFF2244);
  static const success  = Color(0xFF00EE55);
  static const warning  = Color(0xFFFFCC00);
  static const gold     = Color(0xFFFFD700);
  static const nuke     = Color(0xFFCC33FF);

  // ── Text on dark ──
  static const text      = Color(0xFFFFFFFF);
  static Color get textDim   => Colors.white.withOpacity(0.70);
  static Color get textMuted => Colors.white.withOpacity(0.54);
  static Color get textFaint => Colors.white.withOpacity(0.38);
  static const onAction  = Color(0xFF000A14); // text on orange buttons

  // ── World accents (campaign sectors) ──
  static const worldDawn   = Color(0xFFFFAA00); // W1 Dawn Sector
  static const worldMidday = Color(0xFF00AAFF); // W2 Midday Front
  static const worldDusk   = Color(0xFFFF5500); // W3 Dusk Zone
  static const worldNight  = Color(0xFF9933FF); // W4 Night Ops
  static const worlds = [worldDawn, worldMidday, worldDusk, worldNight];

  // ── Jet skin accents ──
  static const skinCobalt  = Color(0xFF0088FF);
  static const skinCrimson = Color(0xFFFF2244);
  static const skinSolar   = Color(0xFFFFBB00);
  static const skinEmerald = Color(0xFF00EE55);

  // ── Radii ──
  static const rSm = 8.0, rMd = 12.0, rLg = 16.0, rXl = 20.0, rModal = 24.0, rPill = 32.0;

  // ── Spacing scale ──
  static const s1 = 4.0, s2 = 6.0, s3 = 8.0, s4 = 12.0, s5 = 16.0,
               s6 = 20.0, s7 = 24.0, s8 = 32.0, s10 = 48.0;

  // ── Strokes / bars ──
  static const stroke = 1.5, strokeBold = 2.0;
  static const barThin = 4.0, bar = 6.0;
  static const hitMin = 44.0; // min tappable

  // ── Motion ──
  static const easeFast = Duration(milliseconds: 120);
  static const ease     = Duration(milliseconds: 200); // chip/nav selection
  static const easeSlow = Duration(milliseconds: 300); // tab switch
  static const easeCurve = Cubic(0.2, 0.7, 0.2, 1);
}

// ── Signature gradients ──
const afActionGradient = LinearGradient(
  begin: Alignment.topCenter, end: Alignment.bottomCenter,
  colors: [Color(0xFFFF8800), Color(0xFFFF4400)],
);

// ── Glow / shadow helpers ──
List<BoxShadow> afGlow(Color c, {double blur = 16, double opacity = 0.55, Offset offset = Offset.zero}) =>
    [BoxShadow(color: c.withOpacity(opacity), blurRadius: blur, offset: offset)];

List<BoxShadow> get afGlowOrange =>
    [const BoxShadow(color: Color(0x80FF5500), blurRadius: 20, offset: Offset(0, 5))];

List<BoxShadow> get afShadowPanel =>
    [BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 8))];

List<BoxShadow> get afShadowModal =>
    [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 48, offset: const Offset(0, 16))];

// HUD text shadow — keeps readouts legible over the sky.
const afTextShadowHud = Shadow(color: Color(0xCC000033), blurRadius: 6, offset: Offset(0, 1));

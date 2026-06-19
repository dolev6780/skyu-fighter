// AeroFighter — ready-to-use Flutter widgets matching the design system.
// Copy into lib/widgets/ alongside af_tokens.dart + af_text_styles.dart.
import 'dart:ui';
import 'package:flutter/material.dart';
import 'af_tokens.dart';
import 'af_text_styles.dart';

enum AfButtonVariant { primary, secondary, ghost, danger, success }
enum AfButtonSize { sm, md, lg }

/// The signature CTA. `primary` is the orange-gradient SCRAMBLE button.
class AfButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final AfButtonVariant variant;
  final AfButtonSize size;
  final bool block;
  final bool disabled;
  final VoidCallback? onTap;

  const AfButton(this.label, {super.key, this.icon, this.variant = AfButtonVariant.primary,
      this.size = AfButtonSize.md, this.block = false, this.disabled = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final pad = switch (size) {
      AfButtonSize.sm => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      AfButtonSize.md => const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      AfButtonSize.lg => const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
    };
    final fontSize = switch (size) { AfButtonSize.sm => 12.0, AfButtonSize.md => 15.0, AfButtonSize.lg => 22.0 };

    Color fg = AF.cyan; Color? bgColor; Gradient? grad; Border? border; List<BoxShadow>? shadow;
    switch (variant) {
      case AfButtonVariant.primary:
        grad = afActionGradient; fg = AF.onAction; shadow = afGlowOrange; break;
      case AfButtonVariant.secondary:
        fg = AF.cyan; border = Border.all(color: AF.cyanMid, width: AF.stroke); break;
      case AfButtonVariant.ghost:
        fg = AF.cyan; bgColor = AF.cyanMid.withValues(alpha: 0.08); break;
      case AfButtonVariant.danger:
        fg = AF.danger; border = Border.all(color: AF.danger, width: AF.stroke); break;
      case AfButtonVariant.success:
        fg = AF.success; border = Border.all(color: AF.success, width: AF.stroke); break;
    }
    if (disabled) { grad = null; bgColor = AF.borderInactive; fg = AF.textFaint; shadow = null; border = null; }

    final child = Row(
      mainAxisSize: block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: fontSize + 4, color: fg), const SizedBox(width: 10)],
        Text(label.toUpperCase(), style: TextStyle(
          fontFamily: 'ChakraPetch', fontWeight: FontWeight.w700, fontSize: fontSize,
          letterSpacing: size == AfButtonSize.lg ? 2 : 1.5, color: fg,
          fontStyle: size == AfButtonSize.lg && variant == AfButtonVariant.primary
              ? FontStyle.italic : FontStyle.normal)),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(AF.rMd),
        child: Container(
          padding: pad,
          constraints: BoxConstraints(minHeight: size == AfButtonSize.lg ? 64 : 48),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor, gradient: grad, border: border,
            borderRadius: BorderRadius.circular(AF.rMd), boxShadow: shadow),
          child: child,
        ),
      ),
    );
  }
}

/// Translucent navy cockpit surface.
class AfPanel extends StatelessWidget {
  final Widget child;
  final Color? accent;
  final bool glow;
  final EdgeInsets padding;
  final double radius;
  const AfPanel({super.key, required this.child, this.accent, this.glow = false,
      this.padding = const EdgeInsets.all(AF.s7), this.radius = AF.rMd});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AF.surface.withValues(alpha: 0.85),
          border: Border.all(color: accent ?? AF.border, width: AF.stroke),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: glow && accent != null ? afGlow(accent!, opacity: 0.4) : afShadowPanel,
        ),
        child: child,
      );
}

/// Frosted-glass modal (GAME OVER / MISSION COMPLETE / PAUSED). Wrap your content.
class AfGlassModal extends StatelessWidget {
  final Widget child;
  final Color accent;
  final bool glow;
  final double width;
  const AfGlassModal({super.key, required this.child, this.accent = AF.cyanMid,
      this.glow = false, this.width = 360});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AF.rModal),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: width,
            padding: const EdgeInsets.all(AF.s7),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              border: Border.all(color: accent.withValues(alpha: 0.4), width: AF.stroke),
              borderRadius: BorderRadius.circular(AF.rModal),
              boxShadow: glow ? [...afShadowModal, ...afGlow(accent, blur: 30, opacity: 0.4)] : afShadowModal,
            ),
            child: child,
          ),
        ),
      );
}

/// Labeled stat bar (ENGINE SPEED / HULL INTEGRITY / FIREPOWER).
class AfStatBar extends StatelessWidget {
  final String label;
  final double value; // 0..1
  final Color color;
  const AfStatBar({super.key, required this.label, this.value = 0.6, this.color = AF.cyan});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label.toUpperCase(), style: AFType.caption),
            Text('${(value * 100).round()}%',
                style: const TextStyle(fontFamily: 'ShareTechMono', fontSize: 11, fontWeight: FontWeight.w700)
                    .copyWith(color: color)),
          ]),
          const SizedBox(height: 4),
          AfProgressBar(value: value, color: color, height: AF.bar),
        ],
      );
}

/// Thin HUD progress / timer track with optional glow.
class AfProgressBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final double height;
  final bool glow;
  const AfProgressBar({super.key, this.value = 0.5, this.color = AF.orange,
      this.height = AF.barThin, this.glow = true});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(AF.rSm),
        child: Container(
          height: height, color: Colors.black.withValues(alpha: 0.45),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0, 1),
            child: Container(decoration: BoxDecoration(
                color: color, boxShadow: glow ? afGlow(color, blur: 8, opacity: 1) : null)),
          ),
        ),
      );
}

/// Campaign sector selector chip (W1 DAWN SECTOR … W4 NIGHT OPS).
class AfWorldChip extends StatelessWidget {
  final int id;
  final String name;
  final Color accent;
  final bool selected;
  final bool locked;
  final VoidCallback? onTap;
  const AfWorldChip({super.key, required this.id, required this.name, required this.accent,
      this.selected = false, this.locked = false, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: locked ? null : onTap,
        child: AnimatedContainer(
          duration: AF.ease,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? accent.withValues(alpha: 0.16) : Colors.black.withValues(alpha: 0.25),
            border: Border.all(
                color: selected ? accent : AF.borderInactive, width: selected ? 2 : 1.2),
            borderRadius: BorderRadius.circular(AF.rMd),
            boxShadow: selected ? afGlow(accent, blur: 14, opacity: 0.5) : null,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (locked)
              Icon(Icons.lock, size: 16, color: AF.textMuted)
            else
              Container(width: 12, height: 12, decoration: BoxDecoration(
                  color: accent, shape: BoxShape.circle, boxShadow: afGlow(accent, blur: 8, opacity: 1))),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text('W$id', style: const TextStyle(fontFamily: 'ShareTechMono', fontSize: 9, letterSpacing: 1)
                  .copyWith(color: AF.textMuted)),
              Text(name, style: TextStyle(fontFamily: 'ChakraPetch', fontSize: 11, fontWeight: FontWeight.w700,
                  letterSpacing: 1, color: selected ? AF.text : AF.textMuted)),
            ]),
          ]),
        ),
      );
}

/// Status pill (EQUIPPED / READY) — solid or outline.
class AfBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool outline;
  const AfBadge(this.label, {super.key, this.color = AF.cyan, this.outline = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: outline ? Colors.transparent : color,
          border: outline ? Border.all(color: color) : null,
          borderRadius: BorderRadius.circular(AF.rSm),
        ),
        child: Text(label.toUpperCase(), style: TextStyle(
          fontFamily: 'ChakraPetch', fontSize: 10, fontWeight: FontWeight.w700,
          letterSpacing: 2, color: outline ? color : AF.onAction)),
      );
}

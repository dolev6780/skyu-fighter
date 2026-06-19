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
  /// Override: render a solid button filled with this color (white text + glow).
  /// Used by modal CTAs whose accent is dynamic — GAME OVER red, PAUSED blue,
  /// MISSION COMPLETE per-world. Ignored when [variant] is primary.
  final Color? fillColor;

  const AfButton(this.label, {super.key, this.icon, this.variant = AfButtonVariant.primary,
      this.size = AfButtonSize.md, this.block = false, this.disabled = false, this.onTap,
      this.fillColor});

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
    if (fillColor != null && variant != AfButtonVariant.primary) {
      bgColor = fillColor; grad = null; border = null; fg = AF.text;
      shadow = afGlow(fillColor!, blur: 16, opacity: 0.45);
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

/// Circular (or rounded) icon-only control — pause, wifi, top-bar actions.
class AfIconButton extends StatelessWidget {
  final IconData icon;
  final String? semanticLabel;
  final bool active;
  final double size;
  final Color color;
  final bool circle;
  final VoidCallback? onTap;
  const AfIconButton(this.icon, {super.key, this.semanticLabel, this.active = false,
      this.size = AF.hitMin, this.color = AF.cyan, this.circle = true, this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
        label: semanticLabel, button: true,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: size, height: size, alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: active ? afActionGradient : null,
              color: active ? null : AF.surface.withValues(alpha: 0.6),
              shape: circle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: circle ? null : BorderRadius.circular(AF.rMd),
              border: active ? null : Border.all(color: AF.border, width: AF.stroke),
              boxShadow: active ? afGlowOrange : null,
            ),
            child: Icon(icon, size: size * 0.5, color: active ? AF.onAction : color),
          ),
        ),
      );
}

/// Pilot avatar — cyan-ringed circle with a person glyph, initials, or image.
class AfAvatar extends StatelessWidget {
  final ImageProvider? image;
  final String? initials;
  final IconData icon;
  final double size;
  final Color ring;
  const AfAvatar({super.key, this.image, this.initials, this.icon = Icons.person,
      this.size = 48, this.ring = AF.cyanMid});

  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size, alignment: Alignment.center, clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle, color: AF.bg,
          border: Border.all(color: ring, width: AF.stroke)),
        child: image != null
            ? Image(image: image!, fit: BoxFit.cover, width: size, height: size)
            : initials != null
                ? Text(initials!, style: TextStyle(color: AF.cyan, fontFamily: 'ChakraPetch',
                    fontWeight: FontWeight.w700, fontSize: size * 0.36, letterSpacing: 1))
                : Icon(icon, color: AF.cyan, size: size * 0.55),
      );
}

/// One tab in [AfNavBar].
class AfNavItem {
  final IconData icon;
  final String label;
  const AfNavItem(this.icon, this.label);
}

/// Floating bottom tab bar (HOME / HANGAR / SHOP / PILOT).
class AfNavBar extends StatelessWidget {
  final List<AfNavItem> items;
  final int value;
  final ValueChanged<int> onChange;
  const AfNavBar({super.key, required this.items, this.value = 0, required this.onChange});

  @override
  Widget build(BuildContext context) => Container(
        height: 75, padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AF.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(AF.rXl),
          border: Border.all(color: AF.border, width: AF.stroke),
          boxShadow: afShadowPanel),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < items.length; i++)
              _AfNavTile(item: items[i], selected: i == value, onTap: () => onChange(i)),
          ],
        ),
      );
}

class _AfNavTile extends StatelessWidget {
  final AfNavItem item;
  final bool selected;
  final VoidCallback onTap;
  const _AfNavTile({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AF.onAction : AF.cyanMid;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AF.ease, width: 65, height: 60,
        decoration: BoxDecoration(
          color: selected ? AF.orange : null,
          borderRadius: BorderRadius.circular(AF.rLg),
          boxShadow: selected ? afGlow(AF.orangeHot, blur: 12, opacity: 0.4) : null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: fg, size: 24),
            const SizedBox(height: 4),
            Text(item.label.toUpperCase(), style: TextStyle(
              color: fg, fontFamily: 'ChakraPetch', fontSize: 9,
              fontWeight: FontWeight.w700, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

/// One option in [AfSegmented].
class AfSegment {
  final String label;
  final Color? color;
  const AfSegment(this.label, {this.color});
}

/// Segmented selector — DIFFICULTY SCALE (EASY / NORMAL / HARD).
class AfSegmented extends StatelessWidget {
  final List<AfSegment> options;
  final int value;
  final ValueChanged<int> onChange;
  final Color activeColor;
  const AfSegmented({super.key, required this.options, this.value = 0,
      required this.onChange, this.activeColor = AF.blue});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _seg(options[i], i == value, () => onChange(i)),
            )),
        ],
      );

  Widget _seg(AfSegment opt, bool selected, VoidCallback onTap) {
    final col = opt.color ?? activeColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AF.ease,
        padding: const EdgeInsets.symmetric(vertical: 10), alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? col.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AF.rSm),
          border: Border.all(color: selected ? col : AF.borderQuiet, width: AF.stroke)),
        child: Text(opt.label.toUpperCase(), style: TextStyle(
          color: selected ? AF.text : AF.textMuted, fontFamily: 'ChakraPetch',
          fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
      ),
    );
  }
}

/// Settings switch — themed color when on, dark track when off.
class AfToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;
  const AfToggle({super.key, required this.value, required this.onChanged, this.color = AF.cyan});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: AF.ease, width: 50, height: 28, padding: const EdgeInsets.all(3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? color : AF.borderInactive,
            borderRadius: BorderRadius.circular(999),
            boxShadow: value ? afGlow(color, blur: 10, opacity: 1) : null),
          child: Container(width: 22, height: 22, decoration: BoxDecoration(
            shape: BoxShape.circle, color: value ? AF.bg : Colors.white.withValues(alpha: 0.5))),
        ),
      );
}

/// Hangar jet-selector chip.
class AfJetChip extends StatelessWidget {
  final Color color;
  final bool highlighted;
  final bool equipped;
  final VoidCallback? onTap;
  const AfJetChip({super.key, required this.color, this.highlighted = false,
      this.equipped = false, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AF.ease, width: 60, height: 64,
          decoration: BoxDecoration(
            color: highlighted ? AF.cyanMid.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(AF.rMd),
            border: Border.all(
              color: highlighted ? AF.cyan : (equipped ? AF.cyanMid.withValues(alpha: 0.5) : AF.borderInactive),
              width: highlighted ? 2 : 1.2)),
          child: Stack(alignment: Alignment.center, children: [
            Container(width: 24, height: 24, decoration: BoxDecoration(
              shape: BoxShape.circle, color: color,
              boxShadow: afGlow(color, blur: 8, opacity: 0.6))),
            if (equipped)
              const Positioned(top: 2, right: 2,
                child: Icon(Icons.check_circle, size: 13, color: AF.success)),
          ]),
        ),
      );
}

/// Power-up metadata — order matches the game's sprite strip (frame index).
class AfPowerUp {
  final String key;
  final String label;
  final Color color;
  final IconData icon;
  const AfPowerUp(this.key, this.label, this.color, this.icon);
}

const afPowerUps = <AfPowerUp>[
  AfPowerUp('weaponUp',  'WEAPON UP',       Color(0xFFFF8800), Icons.arrow_circle_up),
  AfPowerUp('rapidFire', 'RAPID FIRE',      Color(0xFFFFFF33), Icons.bolt),
  AfPowerUp('missiles',  'MISSILES',        Color(0xFFFF3333), Icons.rocket),
  AfPowerUp('repair',    'SYSTEM REPAIRED', Color(0xFF33FF33), Icons.healing),
  AfPowerUp('extraLife', 'EXTRA LIFE',      Color(0xFFFFFFFF), Icons.favorite),
  AfPowerUp('armor',     'ARMOR',           Color(0xFF3388FF), Icons.shield),
  AfPowerUp('nuke',      'TACTICAL NUKE',   Color(0xFFCC33FF), Icons.dangerous),
  AfPowerUp('scoreStar', 'SCORE STAR',      Color(0xFFFFD700), Icons.star),
];

/// Glowing ringed power-up badge for menu/HUD widget surfaces.
class AfPowerUpBadge extends StatelessWidget {
  final int type; // frame index 0..7
  final double size;
  final bool ring;
  const AfPowerUpBadge({super.key, this.type = 0, this.size = 56, this.ring = true});

  @override
  Widget build(BuildContext context) {
    final meta = afPowerUps[type.clamp(0, afPowerUps.length - 1)];
    return Container(
      width: size, height: size, alignment: Alignment.center,
      decoration: ring
          ? BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [meta.color.withValues(alpha: 0.28), meta.color.withValues(alpha: 0.05), Colors.transparent],
                stops: const [0.0, 0.7, 1.0]),
              border: Border.all(color: meta.color.withValues(alpha: 0.6), width: AF.stroke),
              boxShadow: afGlow(meta.color, blur: 14, opacity: 0.5))
          : null,
      child: Icon(meta.icon, size: size * 0.46, color: meta.color),
    );
  }
}

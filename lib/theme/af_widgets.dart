import 'dart:ui';
import 'package:flutter/material.dart';
import 'af_tokens.dart';
import 'af_text_styles.dart';

class AfButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AfButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: actionGradient,
        borderRadius: BorderRadius.circular(AF.rPill),
        boxShadow: [
          BoxShadow(
            color: AF.orange.withOpacity(0.5),
            blurRadius: 20,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AF.rPill),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AF.s7, vertical: AF.s5),
            child: Text(
              text.toUpperCase(),
              style: AFText.label.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class AfPanel extends StatelessWidget {
  final Widget child;

  const AfPanel({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AF.surface.withOpacity(0.85),
        border: Border.all(color: AF.border, width: 2),
        borderRadius: BorderRadius.circular(AF.rModal),
        boxShadow: [
          BoxShadow(
            color: AF.cyan.withOpacity(0.2),
            blurRadius: 16,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AF.rModal),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Padding(
            padding: const EdgeInsets.all(AF.s7),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AfStatBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double height;

  const AfStatBar({
    Key? key,
    required this.progress,
    this.color = AF.cyan,
    this.height = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AF.bg,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: AF.border),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(height / 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AfWorldChip extends StatelessWidget {
  final String label;
  final Color color;

  const AfWorldChip({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AF.s5, vertical: AF.s4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(AF.rControl),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
          )
        ],
      ),
      child: Text(
        label.toUpperCase(),
        style: AFText.label.copyWith(color: color),
      ),
    );
  }
}

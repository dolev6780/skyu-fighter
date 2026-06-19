import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart' hide Image;
import 'main.dart';

class Explosion extends SpriteAnimationComponent with HasGameReference<AeroFighterGame> {
  final double explosionSize;

  Explosion({required Vector2 position, required this.explosionSize})
      : super(
          position: position,
          size: Vector2.all(explosionSize),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    final sheet = SpriteSheet(
      image: game.images.fromCache('fighter_jet_explosion_256.png'),
      srcSize: Vector2.all(256),
    );
    animation = sheet.createAnimation(row: 0, stepTime: 0.07, loop: false);

    // Add particle sparks
    final rnd = Random();
    game.world.add(
      ParticleSystemComponent(
        position: position.clone(),
        particle: Particle.generate(
          count: 15,
          lifespan: 0.6,
          generator: (i) {
            final speed = rnd.nextDouble() * 150 + 50;
            final angle = rnd.nextDouble() * 2 * pi;
            return AcceleratedParticle(
              acceleration: Vector2(0, 100), // Gravity
              speed: Vector2(cos(angle), sin(angle)) * speed,
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  final opacity = (1 - particle.progress).clamp(0.0, 1.0);
                  canvas.drawCircle(
                    Offset.zero,
                    rnd.nextDouble() * 3 + 1,
                    Paint()
                      ..color = const Color(0xFFFF8800).withValues(alpha: opacity)
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
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
  }
}

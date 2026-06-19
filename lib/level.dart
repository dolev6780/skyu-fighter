import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LevelBlock extends PositionComponent {
  LevelBlock({required Vector2 position, required Vector2 size}) 
    : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    
    // 2.5D Deep Shadow (gives it a floating/depth feel)
    final shadowPaint = Paint()
      ..color = const Color(0x99000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawRect(rect.shift(const Offset(8, 12)), shadowPaint);

    // Front Face (Earth/Dirt gradient)
    final facePaint = Paint()
      ..shader = LinearGradient(
        colors: const [Color(0xFF8B4513), Color(0xFF4A2508)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, facePaint);

    // Grass Top
    final grassPaint = Paint()..color = const Color(0xFF32CD32);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 14), grassPaint);

    // Grass Highlight
    final grassHighlight = Paint()..color = const Color(0xFF7CFC00);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 4), grassHighlight);

    // Inner Bevel (simulates 3D edges)
    final borderPaint = Paint()
      ..color = const Color(0x66000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(rect, borderPaint);
  }
}

class Level {
  static List<LevelBlock> generateLevel() {
    List<LevelBlock> blocks = [];

    // Ground floor
    for (int i = -10; i < 60; i++) {
      if (i == 10 || i == 11 || i == 25 || i == 26 || i == 27) continue; // Pits
      blocks.add(LevelBlock(
        position: Vector2(i * 64.0, 400.0),
        size: Vector2(64, 64),
      ));
      // Deep ground to hide bottom
      blocks.add(LevelBlock(
        position: Vector2(i * 64.0, 464.0),
        size: Vector2(64, 400),
      ));
    }

    // Platforms
    blocks.add(LevelBlock(position: Vector2(300, 250), size: Vector2(64 * 3, 32)));
    blocks.add(LevelBlock(position: Vector2(600, 150), size: Vector2(64 * 2, 32)));
    blocks.add(LevelBlock(position: Vector2(900, 200), size: Vector2(64 * 4, 32)));
    
    // High platforms over a pit
    blocks.add(LevelBlock(position: Vector2(1450, 150), size: Vector2(64, 32)));
    blocks.add(LevelBlock(position: Vector2(1650, 100), size: Vector2(64, 32)));
    
    // Stairs
    for (int i = 0; i < 5; i++) {
      blocks.add(LevelBlock(
        position: Vector2(2000 + i * 64.0, 400.0 - (i+1) * 64.0),
        size: Vector2(64, (i+1) * 64.0 + 400),
      ));
    }
    
    // Final high platform
    blocks.add(LevelBlock(position: Vector2(2320, 80), size: Vector2(64 * 10, 32)));

    return blocks;
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';  // 追加
import 'package:flame/components.dart';

import '../../constants/constants.dart';
import 'ball.dart';  // 追加


class Block extends RectangleComponent with CollisionCallbacks {
  Block({required this.blockSize})
      : super(
          size: blockSize,
          paint: Paint()
            ..color = kBlockColors[Random().nextInt(kBlockColors.length)],
        );

  final Vector2 blockSize;

  @override
  Future<void>? onLoad() async {  // メソッド追加
    final blockHitbox = RectangleHitbox(
      size: size,
    );

    await add(blockHitbox);

    return super.onLoad();
  }

  @override
  void onCollisionStart(  // メソッド追加
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Ball) {
      removeFromParent();
    }

    super.onCollisionStart(intersectionPoints, other);
  }
}
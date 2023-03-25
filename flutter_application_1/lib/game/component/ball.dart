import 'dart:math';   // 追加
import 'dart:ui';

import 'package:flame/collisions.dart';  // 追加
import 'package:flame/components.dart';

import '../../constants/constants.dart';
import 'block.dart' as b;  // 追加
import 'paddle.dart';  // 追加

class Ball extends CircleComponent with CollisionCallbacks {
  Ball() {
    radius = kBallRadius;
    paint = Paint()..color = kBallColor;

        final vx = kBallSpeed * cos(spawnAngle * kRad);  // 追加
    final vy = kBallSpeed * sin(spawnAngle * kRad);  // 追加
    velocity = Vector2(vx, vy);  // 追加
  }

  late Vector2 velocity;  // 追加

  bool isCollidedScreenHitboxX = false;  // 追加
  bool isCollidedScreenHitboxY = false;  // 追加

  double get spawnAngle {  // メソッド追加
    final random = Random().nextDouble();
    final spawnAngle =
        lerpDouble(kBallMinSpawnAngle, kBallMaxSpawnAngle, random)!;
    return spawnAngle;
  }

    @override
  Future<void> onLoad() async {  // メソッド追加 ?いらない
    final hitbox = CircleHitbox(radius: radius);

    await add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {  // メソッド追加
    position += velocity * dt * 0.3;
    super.update(dt);
  }

    @override
  void onCollisionStart(  // メソッド追加
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    final collisionPoint = intersectionPoints.first;

    if (other is b.Block) {  // 条件分岐追加
      final blockRect = other.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, blockRect);
    }

    if (other is Paddle) {
      final paddleRect = other.toAbsoluteRect();

      updateBallTrajectory(collisionPoint, paddleRect);
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {  // メソッド追加
    if (other is ScreenHitbox) {
      final screenHitBoxRect = other.toAbsoluteRect();

      for (final point in intersectionPoints) {
        if (point.x == screenHitBoxRect.left && !isCollidedScreenHitboxX) {
          velocity.x = -velocity.x;
          isCollidedScreenHitboxX = true;
        }
        if (point.x == screenHitBoxRect.right && !isCollidedScreenHitboxX) {
          velocity.x = -velocity.x;
          isCollidedScreenHitboxX = true;
        }
        if (point.y == screenHitBoxRect.top && !isCollidedScreenHitboxY) {
          velocity.y = -velocity.y;
          isCollidedScreenHitboxY = true;
        }
        if (point.y == screenHitBoxRect.bottom && !isCollidedScreenHitboxY) {
          removeFromParent();
        }
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {  // メソッド追加
    isCollidedScreenHitboxX = false;
    isCollidedScreenHitboxY = false;
    super.onCollisionEnd(other);
  }

  void updateBallTrajectory(  // メソッド追加
    Vector2 collisionPoint,
    Rect rect,
  ) {
    final isLeftHit = collisionPoint.x == rect.left;
    final isRightHit = collisionPoint.x == rect.right;
    final isTopHit = collisionPoint.y == rect.top;
    final isBottomHit = collisionPoint.y == rect.bottom;

    final isLeftOrRightHit = isLeftHit || isRightHit;
    final isTopOrBottomHit = isTopHit || isBottomHit;

    if (isLeftOrRightHit) {
      if (isRightHit && velocity.x > 0) {
        velocity.x += kBallNudgeSpeed;
        return;
      }

      if (isLeftHit && velocity.x < 0) {
        velocity.x -= kBallNudgeSpeed;
        return;
      }

      velocity.x = -velocity.x;
      return;
    }

    if (isTopOrBottomHit) {
      velocity.y = -velocity.y;
      if (Random().nextInt(kBallRandomNumber) % kBallRandomNumber == 0) {
        velocity.x += kBallNudgeSpeed;
      }
    }
  }

  
}
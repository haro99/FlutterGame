import 'dart:ui';

import 'package:flame/collisions.dart';  // 追加
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';  // 追加

import '../../constants/constants.dart';

class Paddle extends RectangleComponent with CollisionCallbacks, DragCallbacks {  // 修正
  Paddle({required this.draggingPaddle})
      : super(
          size: Vector2(kPaddleWidth, kPaddleHeight),
          paint: Paint()..color = kPaddleColor,
        );

  final void Function(DragUpdateEvent event) draggingPaddle;  // 追加

  @override
  Future<void>? onLoad() async {  // メソッド追加
    final paddleHitbox = RectangleHitbox(
      size: size,
    );

    add(paddleHitbox);

    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {  // メソッド追加
    draggingPaddle(event);
    super.onDragUpdate(event);
  }
}
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:piratix/components/player.dart';
import 'package:piratix/piratixel.dart';

class Checkpoint extends SpriteAnimationComponent with HasGameRef<Piratixel>, CollisionCallbacks{
  Checkpoint({position, size}) : super (position: position, size: size);


@override
  FutureOr<void> onLoad() {
    //debugMode = true;
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'), 
    SpriteAnimationData.sequenced(
      amount: 1, 
      stepTime: 1, 
      textureSize: Vector2.all(64)));
    return super.onLoad();
  }


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
      if(other is Player){
      _reachCheckPoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
  
  void _reachCheckPoint() async {
    
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'), 
    SpriteAnimationData.sequenced(
      amount: 26, 
      stepTime: 0.05, 
      loop: false,
      textureSize: Vector2.all(64)));
      
    await animationTicker?.completed;
    animationTicker?.reset();
     
    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'), 
    SpriteAnimationData.sequenced(
      amount: 10, 
      stepTime: 0.05, 
      loop: true,
      textureSize: Vector2.all(64)));
      
    

  }

}
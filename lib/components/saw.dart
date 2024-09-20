import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:piratix/components/custom_hitbox.dart';
import 'package:piratix/piratixel.dart';

class Saw extends SpriteAnimationComponent with HasGameRef <Piratixel>, CollisionCallbacks{
final bool isVertical;
final double offPos;
final double offNeg;
Saw({
  this.isVertical = false,
  this.offNeg = 0.0,
  this.offPos = 0.0,
 position, 
 size}) 
: super (position: position, size:  size);

 // bool _collected = false;
  static const double stepTime = 0.03;

  final   hitbox = CustomHitbox(
    offsetX: 10, 
    offsetY: 10, 
    width: 12, 
    height: 12);

    static const moveSpeed = 50;
    static const tileSize = 16;
    double moveDirection = 1;
    double rangeNeg = 0;
    double rangePos = 0;


  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    priority = -1;


    if(isVertical){
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    }else{
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    add(CircleHitbox(
    ));

    animation = SpriteAnimation.fromFrameData(game.images.fromCache('Traps/Saw/On (38x38).png'), 
    SpriteAnimationData.sequenced(
      amount: 8, 
      stepTime: stepTime, 
      textureSize: Vector2.all(38))
      );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isVertical){
      _moveVertically(dt);
    }else{
      _moveHorizontally(dt);

    }
   
    super.update(dt);
  }
  
  void _moveVertically(double dt) {
     if(position.y >= rangePos){
      moveDirection = -1;
     }else   if(position.y <= rangeNeg){
      moveDirection = 1;
     } 
     position.y += moveDirection * moveSpeed * dt;
  }
  
  void _moveHorizontally(double dt) {
     if(position.x >= rangePos){
      moveDirection = -1;
     }else   if(position.x <= rangeNeg){
      moveDirection = 1;
     } 
     position.x += moveDirection * moveSpeed * dt;
  }


}
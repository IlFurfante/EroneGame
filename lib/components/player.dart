import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:piratix/components/checkpoint.dart';
import 'package:piratix/components/chicken.dart';
import 'package:piratix/components/custom_hitbox.dart';
import 'package:piratix/components/fruit.dart';
import 'package:piratix/components/saw.dart';
import 'package:piratix/components/utils.dart';

import 'collision_block.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/services.dart';
import 'package:piratix/piratixel.dart';

enum PlayerState {idle, running, jumping, falling, hit, appearing, disappearing}


class Player extends SpriteAnimationGroupComponent with HasGameRef<Piratixel>, KeyboardHandler, CollisionCallbacks{
  
  String character;
  Player({position,  this.character = 'Ninja Frog',
  }) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  final double stepTime = 0.05;
  final double _gravity = 9.8;
  final double _jumpoForce = 300;
  final double _terminalVelocity = 360;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPos = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;

  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10, 
    offsetY: 4, 
    width: 14, 
    height: 28);

double fixedDeltaTime = 1/60 ;
double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
    
    _loadAllAnimations();
    startingPos = Vector2(position.x, position.y);
    debugMode = false;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }
  

  @override
  void update(double dt) {
    accumulatedTime += dt;
    while(accumulatedTime >= fixedDeltaTime){
      
    if(!gotHit && !reachedCheckpoint){
    _updatePlayerState();
    _updatePlayerMovement(fixedDeltaTime);
    _checkHorizontalCollisions();
    _applyGravity(fixedDeltaTime);
    _checkVerticallCollisions();
    }
    accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }


  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.keyW)  || keysPressed.contains(LogicalKeyboardKey.arrowUp);

    return super.onKeyEvent(event, keysPressed);
  }



@override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
      if(!reachedCheckpoint){
    if(other is Fruit){
      
      other.collidedWithPlayer();
    } 
     if(other is Saw){
      _respawn();
    }
     if(other is Checkpoint && !reachedCheckpoint){
      _reachCheckpoint();
    }
     if(other is Chicken){
      other.collidedWithPlayer();
    }
    
    }
    super.onCollisionStart(intersectionPoints, other);
  }



  void _loadAllAnimations() {
    idleAnimation  = _spriteAnimation("Idle", 11);
    runningAnimation = _spriteAnimation("Run", 12);
    jumpingAnimation = _spriteAnimation("Jump", 1);
    fallingAnimation = _spriteAnimation("Fall", 1);
    hitAnimation = _spriteAnimation("Hit", 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation("Appearing", 7);
    disappearingAnimation = _specialSpriteAnimation("Desappearing", 7);


  // List of all animations
  animations = {
    PlayerState.idle: idleAnimation,
    PlayerState.running: runningAnimation,
    PlayerState.jumping: jumpingAnimation,
    PlayerState.falling: fallingAnimation,
    PlayerState.hit: hitAnimation,
    PlayerState.appearing: appearingAnimation,
    PlayerState.disappearing: disappearingAnimation,

  };

  // set current animation
  current = PlayerState.idle;
  
  }


  SpriteAnimation _spriteAnimation(String state, int amount) {
    return   SpriteAnimation.fromFrameData(game.images.fromCache("Main Characters/$character/$state (32x32).png"), SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime, 
      textureSize: Vector2.all(32)));

  }



  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return   SpriteAnimation.fromFrameData(game.images.fromCache("Main Characters/$state (96x96).png"), SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime, 
      loop: false,
      textureSize: Vector2.all(96)
      
      ));
      
  }


  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if(velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    }else if(velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();

    }
    //check if moving, set running

    if(velocity.x != 0) playerState = PlayerState.running;

    
    //check if falling, set falling

    if(velocity.y > _gravity) playerState = PlayerState.falling;

    //check if jumping, set jumping

    if(velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }
  
  void _updatePlayerMovement(double dt) {

    if(hasJumped && isOnGround){
      _playerJump(dt);
    }

    if( velocity.y > _gravity*25 && hasJumped) isOnGround = true;

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
  
  void _checkHorizontalCollisions() {
    for(final block in collisionBlocks){
      // handle collision
     if(!block.isPlatform){
      if(checkCollision(this, block)){
        if(velocity.x > 0){
          velocity.x = 0;
          position.x = block.x - hitbox.offsetX - hitbox.width;
          break;
        }
        if(velocity.x < 0){
          velocity.x = 0;
          position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
          break;
        }
      }
     }
    }
  }
  
  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpoForce, _terminalVelocity);
    position.y += velocity.y *dt;
  }
  
  void _checkVerticallCollisions() {  
    for(final block in collisionBlocks){
      // handle collision
     if(!block.isPlatform){
      if(checkCollision(this, block)){
        if(velocity.y > 0){
          velocity.y = 0; 
          // till now they are quicksand
          position.y = block.y - hitbox.height - hitbox.offsetY;
          isOnGround = true;
          break;
        }
        if(velocity.y < 0){
          velocity.y = 0;
          position.y = block.y + block.height - hitbox.offsetY;
          break;
        }
      }
     }else{
        if(checkCollision(this, block)){
        if(velocity.y > 0){
          velocity.y = 0; 
          // till now they are quicksand
          position.y = block.y - hitbox.height - hitbox.offsetY;
          isOnGround = true;
          break;
        }
      }
     }
    }}
    
      void _playerJump(double dt) {
      if(game.playSounds){
        FlameAudio.play('jump.wav',
        volume:  game.soundVolume *.5,
          
        );

      }

        velocity.y = -_jumpoForce;
        position.y += velocity.y * dt;
        isOnGround = false;
        hasJumped = false;
      }
      
        void _respawn() async {
           if(game.playSounds){
        FlameAudio.play('hit.wav',
        volume:  game.soundVolume *.5,
          
        );

      }
          const hitDuration = Duration(milliseconds: 50*7);
            gotHit = true;
          current = PlayerState.hit;

          await animationTicker?.completed;
          animationTicker?.reset();
              scale.x = 1;
            position = startingPos - Vector2.all(96 - 64);
           // gotHit = false;
            current = PlayerState.appearing;

         await animationTicker?.completed;
          animationTicker?.reset();
              position = startingPos;
             _updatePlayerState();
             
         
          Future.delayed(hitDuration, ()=>   gotHit = false);
             /* current = PlayerState.idle;*/
        
         // 
        }
        
          void _reachCheckpoint() async {

            reachedCheckpoint = true;
             if(game.playSounds){
        FlameAudio.play('disappear.wav',
        volume:  game.soundVolume *.5,
          
        );

      }
            if(scale.x > 0){
              position -= Vector2.all(32);
            } else if(scale.x < 0){
              position += Vector2(32, -32);
            }
            current = PlayerState.disappearing;
            
            await animationTicker?.completed;
            animationTicker?.reset();

             reachedCheckpoint = false;
              position = Vector2.all(-640);
              
              const waitToChangeDuration = Duration(seconds: 3);
              
              Future.delayed(waitToChangeDuration, (){
                game.loadNextLevel();
              });
          
          }
  

  void collidedWithEnemy(){
    _respawn();
  }
}
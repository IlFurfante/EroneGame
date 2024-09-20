import 'dart:async';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:piratix/components/jump_button.dart';
import 'package:piratix/components/level.dart';
import 'components/player.dart';

class Piratixel extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks{

late CameraComponent cam;
Player player = Player(character:  'Mask Dude');
late JoystickComponent joyStick;
bool showControl = false;
bool playSounds = true;
double soundVolume = 1.0;

List<String> levelNames = ["Level-01", "Level-01", ];
int currentLevelIndex = 0;

  @override
  Color backgroundColor() => Color.fromARGB(255, 48, 31, 31);

  
  @override
  FutureOr<void> onLoad() async {
    // Load all images into chace
   
    await images.loadAllImages();
    
if(showControl){
    addJoystick();
    addJumpButton();
    } 

    _loadlLevel();
    return super.onLoad();
  }
  
  @override
  void update(double dt) {
   if(showControl){ updateJoystick();
   }
    super.update(dt);
  }

  void addJoystick() {
    priority = 100;
    joyStick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache("HUD/Knob.png"),),
      ),
      knobRadius: 100,
      background: SpriteComponent(
        sprite: Sprite(images.fromCache("HUD/JoyStick.png"),),
      ),
      margin: const EdgeInsets.only(bottom: 32, left: 32),
    );

      
    camera.viewport.add(joyStick..priority = 10);
    add(joyStick ..priority = 10);


  }
  
  
  void addJumpButton() {

    
    add(JumpButton());

  }

  void updateJoystick() {
    switch (joyStick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
      //idle
    }
  }
  
  void loadNextLevel(){
    removeWhere((component) => component is Level);
    if(currentLevelIndex < levelNames.length -1){
      currentLevelIndex++;
      _loadlLevel();
    }else{
     currentLevelIndex = 0;
      _loadlLevel();
    }
  }

  void _loadlLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      final world = Level(
          levelName: levelNames[currentLevelIndex],
          player: player,
        );
        world.priority = -1;
          cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 360);
          cam.viewfinder.anchor = Anchor.topLeft;
          addAll([cam, world]);
    });
         
  }
}
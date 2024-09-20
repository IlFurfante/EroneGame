import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:piratix/components/background_tile.dart';
import 'package:piratix/components/checkpoint.dart';
import 'package:piratix/components/chicken.dart';
import 'package:piratix/components/collision_block.dart';
import 'package:piratix/components/fruit.dart';
import 'package:piratix/components/saw.dart';
import 'package:piratix/piratixel.dart';
import 'player.dart';

class Level extends World with HasGameRef<Piratixel>{
final String levelName;
final Player player;
Level({required this.levelName, required this.player});
late TiledComponent level;
List <CollisionBlock> collisionBlocks = [];

@override
  FutureOr<void> onLoad() async {
    
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16),
    priority: -5);
    add(level);

_scrollingBackground();
_spawningObjects();
_addCollisions();


    //add(Player(character: "Virtual Guy"));
    return super.onLoad();
  }
  
  void _scrollingBackground() {

    final backgroundLayer = level.tileMap.getLayer("Background");  // name of the layer on Tiled
    
        if(backgroundLayer != null){
      final backgroundColor = backgroundLayer.properties.getValue("BackgroundColor");
      final backgroundTile = BackgroundTile(
        color: backgroundColor ?? 'Gray',
        position: Vector2( 0 , 0),
      );
      
      add(backgroundTile);
    }
   

  

  }
  
  void _spawningObjects() {

        final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');
    
    if(spawnPointsLayer != null){
    for(final spawnPoint in spawnPointsLayer!.objects){
      switch(spawnPoint.class_){
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          player.scale.x = 1;
          add(player);
          break;

      case 'Fruit':
      final fruit = Fruit(
        fruit: spawnPoint.name,
        position: Vector2(spawnPoint.x, spawnPoint.y),
        size: Vector2(spawnPoint.width, spawnPoint.height),
      );
      add(fruit);
          break;

      case 'Saw':
      final isVertical = spawnPoint.properties.getValue('isVertical');
      final offPos = spawnPoint.properties.getValue('offPos');
      final offNeg = spawnPoint.properties.getValue('offNeg');
      final saw = Saw(
        isVertical: isVertical,
        offNeg: offNeg,
        offPos: offPos,
        position: Vector2(spawnPoint.x, spawnPoint.y),
        size: Vector2(spawnPoint.width, spawnPoint.height),
      );
      add(saw);
          break;

          case 'Checkpoint':
          final checkpoint = Checkpoint( 
             position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width, spawnPoint.height),
      

          );
        add(checkpoint);
          
          break;

          
      case 'Chicken':
      final offPos = spawnPoint.properties.getValue('OffPos');
      final offNeg = spawnPoint.properties.getValue('OffNeg');
      final chicken = Chicken(
        offNeg: offNeg,
        offPos: offPos,
        position: Vector2(spawnPoint.x, spawnPoint.y),
        size: Vector2(spawnPoint.width, spawnPoint.height),
      );
      add(chicken);
          break;

      }
    }}


  }
  
  void _addCollisions() {

    

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer != null){
      for( final collision in collisionsLayer!.objects){
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
          final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: false,
          );
          
            collisionBlocks.add(block);
            add(block);
        }

      }
    }

    player.collisionBlocks = collisionBlocks;


  }

}
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:piratix/piratixel.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
   CoverScreen({ required this.hasGameStarted});

      Piratixel game = Piratixel();

  @override
  Widget build(BuildContext context) {
    return hasGameStarted ? 
    GameWidget( game: kDebugMode ? Piratixel() : game ) :
    Container(
                alignment: Alignment(0, -0.2),
                child: Row(
                  children: [
                    Text('Play',
                    style: TextStyle(color: Colors.white),
                   ),
                   Icon(
                    Icons.flag,
                   ),
                  ],
                ),
              );
  }
}
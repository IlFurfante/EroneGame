import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piratix/piratixel.dart';
import 'package:piratix/uiPage/coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double ballX = 0;
  double ballY = 0;
  bool hasGameStarted = false;

  Piratixel game = Piratixel();

   startGame(){
  
    //
    
      Piratixel game = Piratixel();
 //return 
 Navigator.push( context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
   GameWidget( game: kDebugMode ? Piratixel() : game )));
  }


  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr, // or TextDirection.rtl
        child:
        Builder(
        builder: (context) => 
          LayoutBuilder(builder: (context, constraints) => 
    Scaffold(
        backgroundColor: const Color.fromARGB(255, 215, 197, 245),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                
                            
                              child: Container(
                                height: constraints.maxHeight/2,
                              //  width: 1500,
                              /*  decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle
                                ),*/
                               // color: Colors.yellow,
                               child: CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 250, 143, 30),
                                radius: constraints.maxHeight/4,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/Background/skull.png'),
                                  radius: constraints.maxHeight/5,
                                 // child: Image.asset('assets/images/Background/skull.png')
                                 )
                               ),
                                
                                
                                        
                                          ),
                              ),
                              
             
              
              IconButton(
                iconSize: 50,
                onPressed: (){
                   Piratixel game = Piratixel();
               
 //return 
 Navigator.push( context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
   GameWidget( game: kDebugMode ? Piratixel() : game )));
              }, icon: Icon(Icons.play_circle_fill_rounded, color: Color.fromRGBO(0, 72, 84, 1)))
                
              
               
                
      
      
          ],),
        ),
      ),
    )
      )
    ));
  
  
  
  }
}
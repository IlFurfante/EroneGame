import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:piratix/piratixel.dart';
import 'package:piratix/uiPage/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  
  runApp(const HomePage());
}

class FruityBuccaneers extends StatelessWidget {
   FruityBuccaneers({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
         // Flexible(child: Image(image: AssetImage('assets/images/Background/starter.jpg'))),
          ElevatedButton(
            child: 
            Text('Start'),
            onPressed: (){
           // GameWidget( game: kDebugMode ? Piratixel() : game );
          },
          )
        ],
      ),
    );
  }
}


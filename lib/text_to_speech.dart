import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// void main(){
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> { 
  FlutterTts ftts = FlutterTts();

  @override
  Widget build(BuildContext context) { 
    return  Scaffold(
          appBar: AppBar(
            title: const Text("Text to Speech in Flutter"),
            backgroundColor: Colors.redAccent,
          ),
          body: Container( 
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
                children: [
                    ElevatedButton(
                      onPressed:() async {

                          //your custom configuration
                          await ftts.setLanguage("en-US");
                          await ftts.setSpeechRate(0.5); //speed of speech
                          await ftts.setVolume(1.0); //volume of speech
                          await ftts.setPitch(1); //pitc of sound

                          //play text to sp
                          var result = await ftts.speak("Hello World, this is Flutter Campus.");
                          if(result == 1){
                              //speaking
                          }else{
                              //not speaking
                          }
                      }, 
                      child: const Text("Text to Speech"))
                ],
            ),
          )
       );
  }
}
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';


//!For background Tasks
void backGroundTask()async{

    var batterybg = Battery();
    int percentagebg = 0;
    FlutterTts ftts = FlutterTts();
    BatteryState batteryState = BatteryState.full;
    late StreamSubscription streamSubscription;
    bool mute = false;
    int sliderVal = 3;
    bool localLang = false;
    final player = AudioPlayer();
  

    Future<void> speaking({required String say})async{
    await ftts.setLanguage("en-US");
    await ftts.setSpeechRate(0.5); //speed of speech
    await ftts.setVolume(1.0); //volume of speech
    await ftts.setPitch(1); //pitc of sound
    await ftts.speak(say);
  }


    void getBatteryState() {
      streamSubscription = batterybg.onBatteryStateChanged.listen((state) {
      batteryState = state;
        });
      }
	

    void getBatteryPerentage() async {
      final level = await batterybg.batteryLevel;
      percentagebg = level;
      }

  void getLang () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    localLang = prefs.getBool("lang") ?? false;
  }

  void getMute () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mute = prefs.getBool("mute") ?? false;
  }

  void getSliderVal () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sliderVal = prefs.getInt("SliderVal") ?? 3;
  }

  void localSpeak ({required String sound}) async {
  await player.play(AssetSource('audio/$sound.mp3'), volume: 1.0);
}


    
  //notchargingIconChange();
    getLang();
    getMute();
    getSliderVal();
    getBatteryState();
    getBatteryPerentage();

    if (batteryState == BatteryState.full && !mute) {

      if (localLang){
      localSpeak(sound: "fullycharged");
      
    }else{
      speaking(say: "Battery is full\nPlease, Remove the charger!\n");}

    }else if(percentagebg == 100 && !mute){
      if (localLang){
      localSpeak(sound: "fullycharged");
      
      
    }else{
      speaking(say: "Battery is full\nPlease, Remove the charger!\n");}
    }

    if (batteryState == BatteryState.discharging && !mute) {
      if (percentagebg <= sliderVal * 10 && sliderVal * 10 != 100){

        if (localLang){
      localSpeak(sound: "plugin");
      await Future.delayed(const Duration(seconds: 7));
      speaking(say: "$percentagebg\nPercent");

    }else{
      speaking(say: "Battery is $percentagebg\nPercent only\nPlease, Connect your charger!");}
      }
    }

														
	
}

const backgroundtask1 = "backgroundtask1";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case backgroundtask1:
        // Code to run in background
        backGroundTask();

        
        break;
    }
    return Future.value(true);
  });
}

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true
  );
  await Workmanager().registerPeriodicTask(
    "1",
    backgroundtask1,
    frequency: const Duration(minutes: 15),
    //constraints: Constraints(
      //networkType: NetworkType.connected,
    //),
  );


  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]).then((value) =>
runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);
  
// This widget is the root of your application.
@override
Widget build(BuildContext context) {
	return MaterialApp(
	title: 'Flutter Demo',
	theme: ThemeData(
		primarySwatch: Colors.indigo,
	),
	home: const MyHomePage(),
  debugShowCheckedModeBanner: false,
	);
}
}

  

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({
	Key? key,
}) : super(key: key);

@override
State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

var battery = Battery();
int percentage = 0;
late Timer timer;
FlutterTts ftts = FlutterTts();

// created a Batterystate of enum type
BatteryState batteryState = BatteryState.full;
late StreamSubscription streamSubscription;
int check5 = 0;
int batteryChargingcheck = 0;
int splash = 0;
bool splashCheck = false;
int  sliderVal = 3; //!persist
bool dark = false; //!persist
bool mute = false; //!persist
bool localLang = false; //!persist
bool onTime = true;
bool initial = false;
bool noDisturb = true;
final player = AudioPlayer();


void persistLang ({required bool lang}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("lang", lang);
}

void persistSliderVal ({required int sliderVal}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt("SliderVal", sliderVal);
}

void persistMute ({required bool mute}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("mute", mute);
}
 
void persistDark ({required bool dark}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("dark", dark);
}


void getLang () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  localLang = prefs.getBool("lang") ?? false;
}


void getMute () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  mute = prefs.getBool("mute") ?? false;
}

void getDark () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dark = prefs.getBool("dark") ?? false;
}

void getSliderVal () async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  sliderVal = prefs.getInt("SliderVal") ?? 3;
}

void localSpeak ({required String sound}) async {
  await player.play(AssetSource('audio/$sound.mp3'), volume: 1.0);
}


Future<void> speaking({required String say})async{
  await ftts.setLanguage("en-US");
  await ftts.setSpeechRate(0.5); //speed of speech
  await ftts.setVolume(1.0); //volume of speech
  await ftts.setPitch(1); //pitc of sound
  await ftts.speak(say);
}

Future<void> checkBattery() async {

  if(batteryState == BatteryState.discharging 
      && percentage > sliderVal * 10 
     ){
    
    if (localLang){
      localSpeak(sound: "batis");
      await Future.delayed(const Duration(seconds: 3));
      speaking(say: "$percentage\nPercent");

    }else{
    speaking(say: "Battery is\n$percentage\nPercent");}

  }else if (batteryState == BatteryState.discharging 
              && percentage <= sliderVal * 10
              && percentage != 100){
                
    if (localLang){
      localSpeak(sound: "plugin");
      await Future.delayed(const Duration(seconds: 7));
      speaking(say: "$percentage\nPercent");

      }else{
    speaking(say: "Battery is low\n\n$percentage\nPercent only\nConnect your charger\nnow");}

  }else if (batteryState == BatteryState.charging){
    if (localLang){
      localSpeak(sound: "charging");
      await Future.delayed(const Duration(seconds: 3));
      speaking(say: "$percentage\nPercent"); 

    }else{
    speaking(say: "Charger is connected\nBattery is\n$percentage\nPercent");}

  }else if(batteryState == BatteryState.full || percentage == 100){

    if (localLang){
      localSpeak(sound: "fully");
      await Future.delayed(const Duration(seconds: 3));
      speaking(say: "$percentage\nPercent");

    }else{
    speaking(say: "Battery is $percentage\nPercent and fully charged");}
  }
  
}																			

@override
void initState() {
	super.initState();
  
	// calling the method to get battery state
	getBatteryState();

  getMute();
  getDark();
  getSliderVal();
  getLang();

	// calling the method to get battery percentage
	Timer.periodic(const Duration(seconds: 1), (timer) async {
  check5 ++;
  splash ++;


  if (batteryState == BatteryState.charging) {
    if (noDisturb) {
      noDisturb = false;
      persistMute(mute: false);
      getMute();
      setState(() {});
    }
  }

  if (batteryState == BatteryState.discharging) {
    if (!noDisturb) {
      noDisturb = true;
    }
  }

  if (batteryState == BatteryState.discharging && percentage == 100) {
    persistMute(mute: true);
    getMute();
    setState(() {});
  }
  
  //!Splash Screen
  if(!splashCheck){
    if(!initial){
      notchargingIconChange();
      getBatteryPerentage();
      initial = true;
    }
  }
  
  if (splash >= 15){
    splashCheck = true;
  }

  if (splashCheck){

  if (batteryState == BatteryState.discharging && percentage < 100) {
      if (!onTime) {

        if (localLang){
            localSpeak(sound: "notfully");
            await Future.delayed(const Duration(seconds: 6));
            speaking(say: "$percentage\nPercent");
  
       }else{
        speaking(say: "Oops!, Charger is disconnected \n Battery is not fully charged");}

        onTime = true;
      }
      }else if(batteryState == BatteryState.discharging && percentage == 100){
        onTime = true;
      }


  if (batteryState == BatteryState.charging && percentage <= sliderVal * 10 ) {

      if (onTime) {

        if (localLang){
            localSpeak(sound: "welldone");
       }else{
        speaking(say: "Well done!\nCharger is Connected");}

        onTime = false;
      }

    }else if(batteryState == BatteryState.charging && percentage > sliderVal * 10){

      if (onTime) {

        if (localLang){
            localSpeak(sound: "charging");
            await Future.delayed(const Duration(seconds: 3));
            speaking(say: "$percentage\nPercent");
    }else{
        speaking(say: "Charger is Connected");}
        onTime = false;
      }

    }

    //for charging UI
    if (batteryState == BatteryState.charging) {
       batteryChargingcheck ++;
      setState(() {});
      if (batteryChargingcheck == 11){
        batteryChargingcheck = 0;
      }
    }



  if (check5 >= 5){

    //mute = getMute();
    //sliderVal = getSliderVal();

    notchargingIconChange();
    getBatteryPerentage();

    if (batteryState == BatteryState.full && !mute) {

      if (localLang){
      localSpeak(sound: "fullycharged");
     
    }else{
      speaking(say: "Battery is full\nPlease, Remove the charger!\n");

      }

    }else if(percentage == 100 && !mute){
      if (localLang){
      localSpeak(sound: "fullycharged");
    }else{
      speaking(say: "Battery is full\nPlease, Remove the charger!\n");}
    }

    if (batteryState == BatteryState.discharging && !mute) {
      if (percentage <= sliderVal * 10 && sliderVal * 10 != 100){

        if (localLang){
      localSpeak(sound: "plugin");
      await Future.delayed(const Duration(seconds: 7));
      speaking(say: "$percentage\nPercent");
      
    }else{
      speaking(say: "Battery is $percentage\nPercent only\nPlease, Connect your charger!");}
      }
    }


    check5 = 0; 
  }
	
														
	}
  }
  
  );
															
}



// method created to display battery percent
void getBatteryPerentage() async {
	final level = await battery.batteryLevel;
	percentage = level;

	setState(() {});
}

// method to know the state of the battery
void getBatteryState() {
	streamSubscription = battery.onBatteryStateChanged.listen((state) {
	batteryState = state;

	setState(() {});
	});
}

int changenum = 0;
void notchargingIconChange(){
  if (percentage >= 0 && percentage < 10){
    changenum = 0;
  }

  if (percentage >= 10 && percentage < 20){
    changenum = 1;
  }

  if (percentage >= 20 && percentage < 30){
    changenum = 2;
  }
  
  if (percentage >= 30 && percentage < 40){
    changenum = 3;
  }

  if (percentage >= 40 && percentage < 50){
    changenum = 4;
  }

  if (percentage >= 50 && percentage < 60){
    changenum = 5;
  }

  if (percentage >= 60 && percentage < 70){
    changenum = 6;
  }

  if (percentage >= 70 && percentage < 80){
    changenum = 7;
  }

  if (percentage >= 80 && percentage < 90){
    changenum = 8;
  }

  if (percentage >= 90 && percentage < 100){
    changenum = 9;
  }

  if (percentage == 100){
    changenum = 10;
  }
  
}

// Custom widget to add different states of battery
// ignore: non_constant_identifier_names
Widget BatteryBuild(BatteryState state) {

  double ht = MediaQuery.of(context).size.height * .60;
  double wt = MediaQuery.of(context).size.width * .60;

  

	switch (state) {

	// first case is for battery full state
	// then it will show green in color
	case BatteryState.full:
		// ignore: sized_box_for_whitespace
		return Container(
		width: wt,
		height: ht,

    child:const Image(image: AssetImage("assets/images/bat10.png"))
		);

	// Second case is when battery is charging
	// then it will show blue in color
	case BatteryState.charging:
		
		// ignore: sized_box_for_whitespace
		return Container(
		width: wt,
		height: ht,

    child:Image(image: AssetImage("assets/images/bat$batteryChargingcheck.png"))
		);

		// third case is when the battery is
		// discharged then it will show red in color
	case BatteryState.discharging:
	default:

		// ignore: sized_box_for_whitespace
		return Container(
		width: wt,
		height: ht,

    child:Image(image: AssetImage("assets/images/bat$changenum.png"))

    );
		
	}
}

@override
Widget build(BuildContext context) {

 double ht = MediaQuery.of(context).size.height;
 double wt = MediaQuery.of(context).size.width;

 Color iconColor = !dark?const Color.fromARGB(255, 2, 190, 49) : const Color.fromARGB(255, 187, 10, 172);
 Color brightColor = const Color.fromARGB(255, 81, 248, 3);
 Color darkColor = const Color.fromARGB(255, 100, 3, 79);
	return Scaffold(
	
	body: Stack(alignment: Alignment.topCenter,
	 children: [Container(
	height: ht,
	width: wt,
	color: !dark ? brightColor : darkColor,
	   child: Center(
	     child: Column(	
	    mainAxisAlignment: MainAxisAlignment.end,
	    children:[
	       
	       // calling the custom widget
	       Stack(alignment: Alignment.center,
	            children:[
	            BatteryBuild(batteryState),
	            Padding(
	              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
	              child: CircleAvatar(
	                      radius: wt * .18,
	                      backgroundColor:   !dark ? brightColor : darkColor,
	                      child: Text("$percentage", 
	                                textAlign: TextAlign.center,
	                                style: TextStyle(
	                                fontWeight: FontWeight.w600,
	                                fontSize: 50,
	                                color:  dark ? brightColor : darkColor,),)
	                        ),
	            ),
	            ]),
	       
	    SizedBox(height: 40,
	               child:Slider(
	           // 10
	           min: 1,
	           max: 10,
	           divisions: 10,
	           // 11
	           label: '${sliderVal * 10}%',
	           // 12
	           value: sliderVal.toDouble(),
	           // 13
	           onChanged: (newValue) {
	            
	               sliderVal = newValue.round();
                 persistSliderVal(sliderVal: sliderVal);
                 getSliderVal();

	               setState(() {});
	           },
	           // 14
	           activeColor: dark ? brightColor : darkColor,
	           inactiveColor: const Color.fromARGB(255, 2, 66, 11),
	         ),
	               ),
   
	    Container(
	      width: double.infinity,
	      height: MediaQuery.of(context).size.height * .20,
	      color: Colors.transparent,
	      child: Row(
	        children: [
	          Expanded(child: Container(
	            color: Colors.transparent,
	            child: Padding(
	              padding: const EdgeInsets.all(5),
	              child: CircleAvatar(
	                      radius: wt * .13,
	                      //backgroundColor:   const Color.fromARGB(255, 241, 120, 50),
	                      backgroundImage: const AssetImage("assets/images/bg1.png"),
	                      child: Padding(
	                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
	                        child: IconButton(
	                             alignment: Alignment.center,
	                             //padding: EdgeInsets.all(10),
	                             onPressed: (){
	                                //speaking(say: "Hello Michael");
	                               if (mute){
                                   persistMute(mute: false,);
                                   getMute();

	                               }else{
                                   persistMute(mute: true,);
                                   getMute();
                                   }
                                  
	                               setState(() {});
	                             },
	                              icon: mute ?const Icon(Icons.volume_off,
	                                         size: 55,
	                                         color: Color.fromARGB(255, 124, 11, 3)
	                                         ,) : const Icon(Icons.volume_up_rounded,
	                                         size: 55,
	                                         color: Color.fromARGB(255, 124, 11, 3)
	                                         ,) 
	                                         ),
	                      ),
	                        ),
	                        ),
	          )),
   
	           Expanded(child: Container(
	            color: Colors.transparent,
	            padding: const EdgeInsets.all(5),
	            child: Container(
	                      padding: const EdgeInsets.all(5),
	                      decoration: const BoxDecoration(
	                      color: Color.fromARGB(255, 2, 66, 11),
	                      borderRadius: BorderRadius.only(
	                                          bottomLeft: Radius.circular(10),
	                                          bottomRight: Radius.circular(10),
	                                          topLeft: Radius.circular(10),
	                                          topRight: Radius.circular(10),
	                                        ),
	                                      ),
	                      child: Container(decoration: BoxDecoration(
	                      color: dark ? brightColor : darkColor,
	                      borderRadius: const BorderRadius.only(
	                                          bottomLeft: Radius.circular(10),
	                                          bottomRight: Radius.circular(10),
	                                          topLeft: Radius.circular(10),
	                                          topRight: Radius.circular(10),
	                                        ),
	                                      ),
	                      child: Text("${sliderVal * 10}", 
	                                textAlign: TextAlign.center,
	                                style: TextStyle(
	                                fontWeight: FontWeight.w200,
	                                fontSize: percentage == 100? 50: 70,
	                                color:  !dark ? brightColor : darkColor,)
	                                ),
	                                      )
	                                      ,),
	           
	          )),
   
	           Expanded(child: Container(
	            color: Colors.transparent,
	            child: Padding(
	              padding: const EdgeInsets.all(5),
	              child: CircleAvatar(
	                      radius: wt * .15,
	                      //backgroundColor:   const Color.fromARGB(255, 241, 120, 50),
	                      backgroundImage: const AssetImage("assets/images/bg1.png"),
	                      child: Padding(
	                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
	                        child: IconButton(
	                             alignment: Alignment.center,
	                             //padding: EdgeInsets.all(10),
	                             onPressed: (){
	                              checkBattery();
	                             },
	                              icon: const Icon(Icons.battery_saver_rounded,
	                                         size: 55,
	                                         color: Color.fromARGB(255, 124, 11, 3),)),
	                      ),
	                        ),
	                        ),
	          )),
	        ],
	      ),
	    )
	       ],
	     ),
	   ),
	 ),

     //!AppBar layer
     Container(
       height: 100,
       width: MediaQuery.of(context).size.width,
       //color: Colors.transparent,
       decoration: BoxDecoration(
          image: DecorationImage(image: dark !=true? const AssetImage("assets/images/appbar1.png"):const AssetImage("assets/images/appbar2.png") ,
            fit: BoxFit.fill),)

     ),

     //!second layer
     Container(
	 height: MediaQuery.of(context).size.height * .50 +100,
	width: MediaQuery.of(context).size.width,
	color: Colors.transparent,
	child: Column(
	          mainAxisAlignment: MainAxisAlignment.start,
	          children: [
             Container(
              color: Colors.transparent,
                height: 40,
             ),
	           Container(
	             color: Colors.transparent,
	             height: MediaQuery.of(context).size.height * 0.50,
	             child: Row(
	               children: [
	                 Container(
	                   width: wt * .30,
	                   color: Colors.transparent,

	                 ),
  
	                 Expanded(
	                   child: Container(
	                     color: Colors.transparent,
	                   )),
  
	                 Container(
	                   width: wt * .30,
	                   color: Colors.transparent,
	                   child: Center(
	                     child: Column(
	                       mainAxisAlignment: MainAxisAlignment.start,
	                       children: [
	                         IconButton(
	                           //padding: EdgeInsets.all(10),
	                           onPressed: (){
                               setState(() {
	                               if (localLang){
                                   persistLang(lang: false);
                                   getLang();
	                               }else{
                                   persistLang(lang: true);
                                   getLang();

	                               }
	                             });
                             },
	                            icon: Icon(Icons.translate_rounded,
	                                       size: 50,
	                                       //color: iconColor,
                                         color: localLang? Colors.red : iconColor,)),
  
	                         SizedBox(height: ht * .10,),
	                   
	                         IconButton(
	                          // padding: EdgeInsets.all(10),
	                           onPressed: (){
	                             setState(() {
	                               if (dark){
                                   persistDark(dark: false);
                                   getDark();
	                               }else{
                                   persistDark(dark: true);
                                   getDark();

	                               }
	                             });
	                           },
	                            icon: Icon(!dark ? Icons.dark_mode_sharp : Icons.sunny,
	                                       size: 50,
	                                       color: iconColor,)),
  
	                         SizedBox(height: ht * .10,),
	                   
	                         IconButton(
	                          // padding: EdgeInsets.all(10),
	                           onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('About'),
                                  backgroundColor: const Color.fromARGB(255, 243, 219, 148),
                                  content: const Text("""This app reminds you to charge your battery the right way.
                                                        
                                                        Adjust the Slider below to set threshold for remindals."""),
                                  actions: <Widget>[
                                    IconButton(
                                      onPressed: () => speaking(say: """This app reminds you to charge your battery the right way. Adjust the Slider below to set threshold for reminders."""),
                                      iconSize: 30,
                                      color: Colors.green,
                                      icon: const Icon(Icons.volume_up_rounded),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
	                            icon: Icon(Icons.info_outline_rounded,
	                                       size: 50,
	                                       color: iconColor,)),
	                       ],
	                     ),
	                   ),
	                 ),
	               ],
	             ),
	           )
	          ],
	),
     ) ,
  
     //!splash Layer
     Container(
	 height: !splashCheck ? ht : 0,
	 width: !splashCheck ? wt : 0,
	 color: Colors.amber,
	 child: Center(
	           child: Column(
	             children: [
	               SizedBox(
	                 height:  !splashCheck ? ht * .80:0,
	                 width: !splashCheck ?wt * .80:0,
	                 child: const Image(image: AssetImage("assets/images/logo.png")),
	                 ),
	               const CircularProgressIndicator(),
	               const Text("Loading...")
	                 ]
	           ),
	 ),
     ) 
     ]
     ),
	);
}
}

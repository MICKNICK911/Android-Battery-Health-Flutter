import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

// void main() {
// runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
@override
Widget build(BuildContext context) {
	return MaterialApp(
	title: 'Flutter Demo',
	theme: ThemeData(
		primarySwatch: Colors.blue,
	),
	home: const MyHomePage(),
	);
}
}

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

// created a Batterystate of enum type
BatteryState batteryState = BatteryState.full;
late StreamSubscription streamSubscription;
																			

@override
void initState() {
	super.initState();
	// calling the method to get battery state
	getBatteryState();

	// calling the method to get battery percentage
	Timer.periodic(const Duration(seconds: 5), (timer) {
	getBatteryPerentage();
														
	});
	
														
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

// Custom widget to add different states of battery
// ignore: non_constant_identifier_names
Widget BatteryBuild(BatteryState state) {
	switch (state) {

	// first case is for battery full state
	// then it will show green in color
	case BatteryState.full:
		// ignore: sized_box_for_whitespace
		return Container(
		width: 200,
		height: 200,
			
		// ignore: prefer_const_constructors
		child: (Icon(
			Icons.battery_full,
			size: 200,
			color: Colors.green,
		)),
		);

	// Second case is when battery is charging
	// then it will show blue in color
	case BatteryState.charging:
		
		// ignore: sized_box_for_whitespace
		return Container(
		width: 200,
		height: 200,
			
		// ignore: prefer_const_constructors
		child: (Icon(
			Icons.battery_charging_full,
			size: 200,
			color: Colors.blue,
		)),
		);

		// third case is when the battery is
		// discharged then it will show red in color
	case BatteryState.discharging:
	default:
		
		// ignore: sized_box_for_whitespace
		return Container(
		width: 200,
		height: 200,
			
		// ignore: prefer_const_constructors
		child: (Icon(
			Icons.battery_alert,
			size: 200,
			color: Colors.red,
		)),
		);
	}
}

@override
Widget build(BuildContext context) {
	return Scaffold(
	appBar: AppBar(
		backgroundColor: Colors.green,
		title: const Text('GeeksforGeeks',
							style: TextStyle(color: Colors.white),),
		centerTitle: true,
	),
	body: Center(
		child: Column(
			
		mainAxisAlignment: MainAxisAlignment.center,
		children:[
			
			// calling the custom widget
			BatteryBuild(batteryState),
			
			// Displaying battery percentage
			Text('Battery Percentage: $percentage',
				style: const TextStyle(fontSize: 24),)
			],
		),
	),
	);
}
}

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/simulate_screen.dart';
import 'models/appliance.dart'; // <-- IMPORTA O MODEL

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartEnergy',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/simulate': (context) {
          final appliances = ModalRoute.of(context)!.settings.arguments as List<Appliance>;
          return SimulateScreen(appliances: appliances);
        },
      },
    );
  }
}

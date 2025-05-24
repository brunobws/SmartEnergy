import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Tipografia moderna
import 'screens/home_screen.dart';
import 'screens/simulate_screen.dart';
import 'models/appliance.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'SmartEnergy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(), // Aplica fonte Roboto
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/simulate': (context) {
          final appliances = ModalRoute.of(context)!.settings.arguments as List<Appliance>;
          return SimulateScreen(appliances: appliances);
        },
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/maintenance_log.dart';
import 'screen/vehicle_info.dart';

void main() {
  runApp(const VehicleMaintenanceApp());
}

class VehicleMaintenanceApp extends StatefulWidget {
  const VehicleMaintenanceApp({super.key});

  @override
  State<VehicleMaintenanceApp> createState() => _VehicleMaintenanceAppState();
}

class _VehicleMaintenanceAppState extends State<VehicleMaintenanceApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Maintenance Tracker',
      debugShowCheckedModeBanner: false,

      // Follow system theme or user selection
      themeMode: _themeMode,

      // Light Mode Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        brightness: Brightness.light,
      ),

      // Dark Mode Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),

      // Navigation setup
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              themeMode: _themeMode,
              onThemeModeChanged: _setThemeMode,
            ),
        '/maintenanceLog': (context) => const MaintenanceLogScreen(),
        '/vehicleInfo': (context) => const VehicleInfoScreen(),
      },
    );
  }
}

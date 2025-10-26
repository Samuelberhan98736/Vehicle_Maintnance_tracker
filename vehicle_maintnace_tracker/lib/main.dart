import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'screen/maintenance_log.dart';
import 'screen/vehicle_info.dart';

void main() {
  runApp(const VehicleMaintenanceApp());
}

class VehicleMaintenanceApp extends StatelessWidget {
  const VehicleMaintenanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Maintenance Tracker',
      debugShowCheckedModeBanner: false,

      //  Follow system theme (auto switches between light/dark)
      themeMode: ThemeMode.system,

      //  Light Mode Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        brightness: Brightness.light,
      ),

      //  Dark Mode Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),

      //  Navigation setup
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/maintenanceLog': (context) => const MaintenanceLogScreen(),
        '/vehicleInfo': (context) => const VehicleInfoScreen(),
      },
    );
  }
}

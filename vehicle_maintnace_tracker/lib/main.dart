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
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/maintenanceLog': (context) => const MaintenanceLogScreen(),
        '/vehicleInfo': (context) => const VehicleInfoScreen(),
      },
    );
  }
}

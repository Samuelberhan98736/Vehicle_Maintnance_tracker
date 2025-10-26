import 'package:flutter/material.dart';
import 'maintenance_log_screen.dart';
import 'expense_tracker_screen.dart';
import 'vehicle_info_screen.dart';
import 'reminders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorSchemeSeed: Colors.teal,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Vehicle Maintenance Tracker"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top buttons for maintenance & vehicle summaries
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildLargeButton(
                      context,
                      title: "Upcoming Maintenance",
                      icon: Icons.build_circle,
                      color: Colors.teal.shade400,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MaintenanceLogScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildLargeButton(
                      context,
                      title: "Vehicle Summaries",
                      icon: Icons.directions_car,
                      color: Colors.indigo.shade400,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VehicleInfoScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Bottom navigation buttons
              Expanded(
                flex: 1,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildNavButton(
                      context,
                      "Maintenance Log Screen",
                      Icons.handyman,
                      Colors.green.shade400,
                      const MaintenanceLogScreen(),
                    ),
                    _buildNavButton(
                      context,
                      "Expense Tracker Screen",
                      Icons.receipt_long,
                      Colors.orange.shade400,
                      const ExpenseTrackerScreen(),
                    ),
                    _buildNavButton(
                      context,
                      "Vehicle Info Screen",
                      Icons.car_repair,
                      Colors.blue.shade400,
                      const VehicleInfoScreen(),
                    ),
                    _buildNavButton(
                      context,
                      "Reminders",
                      Icons.alarm,
                      Colors.purple.shade400,
                      const RemindersScreen(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Large top buttons
  Widget _buildLargeButton(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Small grid buttons
  Widget _buildNavButton(BuildContext context, String title, IconData icon,
      Color color, Widget destination) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

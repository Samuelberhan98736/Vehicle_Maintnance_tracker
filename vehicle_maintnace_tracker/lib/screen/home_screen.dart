import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicle Maintenance Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.surfaceVariant.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car,
                  size: 100, color: colorScheme.primary),
              const SizedBox(height: 20),
              Text(
                'Welcome to Your Vehicle Dashboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // --- Maintenance Log Button ---
              _buildNavButton(
                context,
                title: 'Maintenance Log',
                subtitle: 'View and record your maintenance activities',
                icon: Icons.build_circle_outlined,
                routeName: '/maintenanceLog',
                color: colorScheme.primary,
              ),

              const SizedBox(height: 16),

              // --- Vehicle Info Button ---
              _buildNavButton(
                context,
                title: 'Vehicle Info',
                subtitle: 'Add or view your car details',
                icon: Icons.car_repair_outlined,
                routeName: '/vehicleInfo',
                color: colorScheme.secondary,
              ),

              const SizedBox(height: 30),

              // --- Future Add-ons Placeholder ---
              Text(
                'More features coming soon ',
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String routeName,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme(context).onSurface)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colorScheme(context)
                          .onSurfaceVariant
                          .withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  // helper function for colorScheme inside a widget
  ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
}

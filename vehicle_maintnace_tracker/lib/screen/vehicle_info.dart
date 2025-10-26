import 'package:flutter/material.dart';
import '/model/vehicle.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final List<Vehicle> _vehicles = [];

  final _formKey = GlobalKey<FormState>();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final mileageController = TextEditingController();

  // Add vehicle method
  void _addVehicle() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _vehicles.add(
          Vehicle(
            make: makeController.text.trim(),
            model: modelController.text.trim(),
            year: int.tryParse(yearController.text.trim()) ?? 0,
            milage: double.tryParse(mileageController.text.trim()) ?? 0.0,
          ),
        );
      });

      // clear text fields after adding
      makeController.clear();
      modelController.clear();
      yearController.clear();
      mileageController.clear();
    }
  }

  // Delete vehicle method
  void _deleteVehicle(int index) {
    setState(() => _vehicles.removeAt(index));
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Info'),
        backgroundColor: colorScheme.primaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Vehicle Input Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: makeController,
                    decoration: const InputDecoration(
                      labelText: 'Make',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.factory),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter make' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: modelController,
                    decoration: const InputDecoration(
                      labelText: 'Model',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter model' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter year' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: mileageController,
                    decoration: const InputDecoration(
                      labelText: 'Mileage',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.speed),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter mileage' : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addVehicle,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Vehicle'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),

            // Vehicle List
            Text(
              'Your Vehicles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 10),

            if (_vehicles.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No vehicles added yet.',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _vehicles.length,
                itemBuilder: (context, index) {
                  final v = _vehicles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.directions_car, size: 35),
                      title: Text('${v.make} ${v.model} (${v.year})'),
                      subtitle: Text('Mileage: ${v.milage} mi'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.redAccent,
                        onPressed: () => _deleteVehicle(index),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

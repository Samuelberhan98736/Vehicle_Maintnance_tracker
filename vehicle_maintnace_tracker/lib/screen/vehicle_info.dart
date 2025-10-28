import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'maintenance_log.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  //list to store
  List<Map<String, dynamic>> _vehicles = [];

  
//controller for text
  final _formKey = GlobalKey<FormState>();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final mileageController = TextEditingController();

//diatabase helper instance
  final dbHelper = DatabaseHelper();

//load vehicles when screen starts
@override

void initState(){
  super.initState();
_loadVehicles(); //fetch existing data from sqllite
}


Future<void> _loadVehicles()async{
  final data = await dbHelper.getVehicles(); //fetch data using helper class
  setState(() {
    _vehicles = data; //update state to render the screen
  });
}


  // Add vehicle method to the database
  Future<void> _addVehicle()async {
    if (_formKey.currentState!.validate()) {
      final vehicle = {
        'make': makeController.text,
        'model': modelController.text,
        'year': int.tryParse(yearController.text)??0,
        'mileage': double.tryParse(mileageController.text) ?? 0.0,

      };

      //insert into database
      await dbHelper.insertVehicle(vehicle);

      // clear text fields after adding
      makeController.clear();
      modelController.clear();
      yearController.clear();
      mileageController.clear();


      //relead updates list

      _loadVehicles();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('Vehicle added succefully!')),
      );
    }
  }

  // Delete vehicle method
  Future<void> _deleteVehicle(int id) async {
    await dbHelper.deleteVehicle(id);
    _loadVehicles();
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
//ui
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
                      title: Text('${v['make']} ${v['model']} (${v['year']})'),
                      subtitle: Text('Mileage: ${v['mileage']} mi'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MaintenanceLogScreen(
                              vehicleId: v['id'] as int,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.redAccent,
                        onPressed: () => _deleteVehicle(v['id'] as int),
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

import '/model/vehicle.dart';
import'package:flutter/material.dart';




class VehicleInfoScreen extends StatefulWidget{
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _vehicleInfoScreenState();

}


class _vehicleInfoScreenState extends State<VehicleInfoScreen>{
  final List<Vehicle> _Vehicles = [];



  final _formKey = GlobalKey<FormState>();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final milageController = TextEditingController();


  //add vehicle method

  void _addVehicle(){
    if (_formKey.currentState!.validate()){

      setState((){
        _Vehicles.add(Vehicle(make: makeController.text,
         model: modelController.text, 
         year: int.tryParse(yearController.text) ??0, 
          milage: double.tryParse(milageController.text)?? 0.0,));
      });

      makeController.clear();
      modelController.clear();
      yearController.clear();
      milageController.clear();
  }

}

//dlete vehicle method

void _deleteVehicle(int index){
  setState(() => _vehicles.removeAt(index));
}


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Info')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: makeController, decoration: const InputDecoration(labelText: 'Make'), validator: (v) => v!.isEmpty ? 'Enter make' : null),
                  TextFormField(controller: modelController, decoration: const InputDecoration(labelText: 'Model'), validator: (v) => v!.isEmpty ? 'Enter model' : null),
                  TextFormField(controller: yearController, decoration: const InputDecoration(labelText: 'Year'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Enter year' : null),
                  TextFormField(controller: mileageController, decoration: const InputDecoration(labelText: 'Mileage'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Enter mileage' : null),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _addVehicle,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Vehicle'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Text('Your Vehicles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._vehicles.map((v) => Card(
                  child: ListTile(
                    title: Text('${v.make} ${v.model} (${v.year})'),
                    subtitle: Text('Mileage: ${v.mileage} mi'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteVehicle(_vehicles.indexOf(v)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

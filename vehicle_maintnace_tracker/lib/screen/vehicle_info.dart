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






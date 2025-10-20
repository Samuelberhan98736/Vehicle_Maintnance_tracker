import 'package:flutter/material.dart';

//model for maintenance log
class MaintenanceLog {
  String type;
  String date;
  double cost;
  String notes;


  MaintenanceLog({
    required this.type,
    required this.date,
    required this.cost,
    required this.notes,
});
}


class MaintenanceLogScreen extends StatefulWidget{
  const MaintenanceLogScreen({super.key});
  @override
  State<MaintenanceLogScreen> createState() => _MaintenanceLogScreenState();
}

class _MaintenanceLogScreenState extends State<MaintenanceLogScreen>{
  final List<MaintenanceLog> _logs = [];

  //controllers for input field
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _dateController = TextEditingController();
  final _constController = TextEditingController();
  final _notesController = TextEditingController();


  void _addLog(){
    if(_formKey.currentState!.validate()){
      setState((){
        _logs.add(
          MaintenanceLog(
            type: _typeController.text,
            date: _dateController.text,
            const: double.parse(_constController.text),
            notes: _notesController.text,
          ),

        );
      });
      _clearFields();
    }
  }


  void _deleteLog(int index){
    setState(() {
      _logs.removeAt(index);
    });
  }

  void _editLog(int index){
    final log = _log[index];
    _typeController.text = log.type;
    _dateController.text = log.date;
    _costController.text = log.cost.toString();
    _notesController.text = log.notes;


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(" Edit maintenance log"),
        content: Form(
          key:_formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Service Type'),
                  validator: (v) => v!.isEmpty ? 'Enter service type': null, // if the input value is empty return enter service type
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  validator: (v) => v!.isEmpty ? 'Enter date': null,

                ),
                TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(labelText:'Cost'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Enter cost': null,
                ),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],),
          ),        )
      ),
      actions:[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed:(){
            if(_formKey.currentState!.validate()){
              setState(() {
                _logs[index] = MaintenanceLog(
                  type: _typeController.text,
                  date: _dateController.text,
                  cost: double.parse(_costController.text),
                  notes: _notesController.text,
                );
              });
              _clearFields();
              Navigator.pop(context);
            }
          },
          child: const Text("save Changes"),)
      ],
    );
  }
}
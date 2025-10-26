import 'package:flutter/material.dart';
import '/model/maintenance.dart';

class MaintenanceLogScreen extends StatefulWidget {
  const MaintenanceLogScreen({super.key});

  @override
  State<MaintenanceLogScreen> createState() => _MaintenanceLogScreenState();
}

class _MaintenanceLogScreenState extends State<MaintenanceLogScreen> {
  final List<Maintenance> _logs = [];

  void _addLog() {
    showDialog(
      context: context,
      builder: (context) {
        final typeController = TextEditingController();
        final costController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Maintenance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Type (e.g., Oil Change)')),
              TextField(controller: costController, decoration: const InputDecoration(labelText: 'Cost'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (typeController.text.isNotEmpty && costController.text.isNotEmpty) {
                  setState(() {
                    _logs.add(Maintenance(
                      type: typeController.text,
                      date: DateTime.now(),
                      cost: double.tryParse(costController.text) ?? 0.0,
                    ));
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteLog(int index) {
    setState(() => _logs.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Log')),
      body: _logs.isEmpty
          ? const Center(child: Text('No maintenance records yet.'))
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(log.type),
                    subtitle: Text('Date: ${log.date.toLocal().toString().split(' ')[0]} • Cost: \$${log.cost.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteLog(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

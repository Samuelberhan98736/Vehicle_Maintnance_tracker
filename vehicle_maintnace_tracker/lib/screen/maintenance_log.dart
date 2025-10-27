import 'package:flutter/material.dart';
import '/model/maintenance.dart';
import '/database/database_helper.dart';

class MaintenanceLogScreen extends StatefulWidget {

  final int vehicleId;
  const MaintenanceLogScreen({super.key, required this.vehicleId});

  @override
  State<MaintenanceLogScreen> createState() => _MaintenanceLogScreenState();
}

class _MaintenanceLogScreenState extends State<MaintenanceLogScreen> {
  // List to store all maintenance records
  List<Map<String,dynamic>> _logs = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState(){
    super.initState();
    _loadLogs();
  }


  Future<void>_loadLogs()async{
    final data = await dbHelper.getMaintenanceByVehicle(widget.vehicleId);
    setState(() {
      _logs = data;
    });
  }

  /// Shows a dialog to add a new maintenance log entry
  /// Uses async await pattern for better dialog handling
  Future<void> _addLog() async {
    // Controllers to capture user input from text fields
    final typeController = TextEditingController();
    final costController = TextEditingController();

    // Show dialog and wait for result (returns null if dismissed)
    final result = await showDialog<Map<String,dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Maintenance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input field for maintenance type
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Type (e.g., Oil Change)',
                  hintText: 'Enter maintenance type',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              // Input field for cost
              TextField(
                controller: costController,
                decoration: const InputDecoration(
                  labelText: 'Cost',
                  prefixText: '\$',
                  hintText: '0.00',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            // Cancel button - dismisses dialog without saving
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            // Add button - validates and returns new maintenance object
            ElevatedButton(
              onPressed: () {
                // Validate that both fields have content
                if (typeController.text.trim().isEmpty) {
                  // Show error if type field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a maintenance type'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                if (costController.text.trim().isEmpty) {
                  // Show error if cost field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a cost'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Parse cost and validate it's a valid number
                final cost = double.tryParse(costController.text.trim());
                if (cost == null || cost < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid cost'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Create new maintenance object and return it
                Navigator.pop(context, {
                  'vehicleId': widget.vehicleId,
                  'type': typeController.text.trim(),
                  'date':DateTime.now().toIso8601String(),
                  'cost': cost,
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    // Clean up controllers to prevent memory leaks
    typeController.dispose();
    costController.dispose();

    // If user added a log (didn't cancel), update the state
    if (result != null) {
      await dbHelper.insertMaintenance(result); //save to db
      await _loadLogs();//refresh list

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result['type']} added successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Deletes a maintenance log at the specified index
  /// Shows a confirmation dialog before deleting
  Future<void> _deleteLog(int index) async {
    final log = _logs[index];

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Maintenance'),
          content: Text('Are you sure you want to delete "${log['type']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    // If user confirmed deletion, remove the log
    if (confirm == true && mounted) {
      await dbHelper.deleteMaintenance(_logs[index]['id']);
      await _loadLogs();

      // Show confirmation message


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${log['type']} deleted'),
          duration: const Duration(seconds: 2),
        ),
      );
      }

      
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Log'),
        // Optional: Show total count in subtitle
        bottom: _logs.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(),
              )
            : null,
      ),
      body: _logs.isEmpty
          // Show empty state when no logs exist
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.build_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No maintenance records yet.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add one',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          // Display list of maintenance logs
          : ListView.builder(
              itemCount: _logs.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final log = _logs[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  elevation: 2,
                  child: ListTile(
                    // Icon representing maintenance type
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.build,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // Maintenance type as title
                    title: Text(
                      log['type'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Date and cost as subtitle
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Date: ${_formatDate(log['date'])} • Cost: \$${(log['cost'] ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    // Delete button
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () => _deleteLog(index),
                      tooltip: 'Delete maintenance record',
                    ),
                  ),
                );
              },
            ),
      // Floating action button to add new maintenance
      floatingActionButton: FloatingActionButton(
        onPressed: _addLog,
        tooltip: 'Add maintenance',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Helper method to format date in a readable way
  String _formatDate(dynamic dateValue) {
    try{
      final date = dateValue is DateTime
      ?dateValue
      :DateTime.tryParse(dateValue.toString()) ?? DateTime.now();
    // Format: MMM dd, yyyy ( Jan 15, 2024)
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }catch(_){
      return 'Invalid Date';
    }
}
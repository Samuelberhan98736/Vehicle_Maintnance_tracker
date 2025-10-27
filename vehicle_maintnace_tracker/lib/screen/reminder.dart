import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../notifications/notification_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final dbHelper = DatabaseHelper();
  final messageController = TextEditingController();

  List<Map<String, dynamic>> _vehicles = [];
  int? _selectedVehicleId;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final data = await dbHelper.getVehicles();
    setState(() {
      _vehicles = data;
      if (_vehicles.isNotEmpty) {
        _selectedVehicleId = _vehicles.first['id'] as int;
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _saveReminder() async {
    final messenger = ScaffoldMessenger.of(context);
    if (_vehicles.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Add a vehicle first')));
      return;
    }
    if (_selectedVehicleId == null) {
      messenger.showSnackBar(const SnackBar(content: Text('Please select a vehicle')));
      return;
    }
    if (messageController.text.trim().isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Please enter a message')));
      return;
    }
    if (_selectedDateTime == null) {
      messenger.showSnackBar(const SnackBar(content: Text('Please pick date and time')));
      return;
    }
    if (_selectedDateTime!.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
      messenger.showSnackBar(const SnackBar(content: Text('Pick a future time')));
      return;
    }

    final reminder = {
      'vehicleId': _selectedVehicleId,
      'message': messageController.text.trim(),
      'date': _selectedDateTime!.toIso8601String(),
    };

    await dbHelper.insertReminder(reminder);
    await NotificationService().scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Maintenance Reminder',
      body: messageController.text.trim(),
      scheduledDate: _selectedDateTime!,
    );

    if (mounted) {
      messenger.showSnackBar(const SnackBar(content: Text('Reminder scheduled')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
        backgroundColor: cs.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_vehicles.isEmpty)
              Text('No vehicles available', style: TextStyle(color: cs.onSurfaceVariant))
            else
              DropdownButtonFormField<int>(
                value: _selectedVehicleId,
                items: [
                  for (final v in _vehicles)
                    DropdownMenuItem(
                      value: v['id'] as int,
                      child: Text('${v['make']} ${v['model']} (${v['year']})'),
                    ),
                ],
                onChanged: (val) => setState(() => _selectedVehicleId = val),
                decoration: const InputDecoration(
                  labelText: 'Vehicle',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Reminder Message',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDateTime,
                    icon: const Icon(Icons.event),
                    label: Text(
                      _selectedDateTime == null
                          ? 'Pick Date & Time'
                          : '${_selectedDateTime!.toLocal()}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveReminder,
                icon: const Icon(Icons.notifications_active),
                label: const Text('Save Reminder'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import '../notifications/notification_service.dart';

// After saving to DB
await dbHelper.insertReminder({
  'vehicleId': selectedVehicleId,
  'message': reminderMessage,
  'date': selectedDateTime.toIso8601String(),
});

// Schedule the local notification
await NotificationService().scheduleNotification(
  id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
  title: 'Maintenance Reminder',
  body: reminderMessage,
  scheduledDate: selectedDateTime,
);

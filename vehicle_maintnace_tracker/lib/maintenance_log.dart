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
  const MaintenanceLogScreen
}
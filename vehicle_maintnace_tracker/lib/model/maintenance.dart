
//stores basic vehicle data

class Maintenance {


  
  final int? id; //When a new record is inserted sqllite generats this id
  final String type;
  final  DateTime date;
  final double cost;
  

//contructor
  Maintenance({
    this.id,
    required this.type,
    required this.date,
    required this.cost,
    
});


//covert a maintenance object into a map for data base storage

Map<String, dynamic>toMap(){
  return{
    'id': id,
    'date': date.toIso8601String(),
    'cost': cost,
    'type': type

  };
}



//factory contructor to create a Maintenance object from a database record
factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      id: map['id'],
      type: map['type'],
      date: DateTime.parse(map['date']),
      cost: map['cost'],
    );
  }
}


//s
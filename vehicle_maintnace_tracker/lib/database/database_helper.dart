import 'package:sqflite/sqflite.dart';       // SQLite plugin for Flutter — allows local database storage
import 'package:path/path.dart';             // Helps build correct file paths on all platforms
import 'package:path_provider/path_provider.dart'; // Lets us find safe directories on the device (e.g., app folder)
import 'dart:io';                            // For working with the file system (needed for directories)

// ======================================================================
// DATABASE HELPER CLASS
// ======================================================================
// This class handles everything related to local data storage using SQLite.
// It manages opening the database, creating tables, and performing CRUD
// (Create, Read, Update, Delete) operations for vehicles, maintenance logs, 
// and reminders.

class DatabaseHelper {
  // --------------------------------------------------------------
  // Singleton setup: ensures only ONE instance of this class exists.
  // --------------------------------------------------------------
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;   // When you call DatabaseHelper(), this returns the same instance
  DatabaseHelper._internal();              // Private constructor (used only internally)

  static Database? _database;              // Holds our open database instance

  // --------------------------------------------------------------
  // Database details
  // --------------------------------------------------------------
  static const _dbName = 'vehicle_maintenance.db'; // Database file name
  static const _dbVersion = 1;                     // Version number (increment if schema changes)

  // --------------------------------------------------------------
  // Table names
  // --------------------------------------------------------------
  static const vehicleTable = 'vehicles';
  static const maintenanceTable = 'maintenance_logs';
  static const reminderTable = 'reminders';

  // --------------------------------------------------------------
  // Get or initialize the database
  // --------------------------------------------------------------
  Future<Database> get database async {
    // If already opened, reuse it
    if (_database != null) return _database!;

    // Otherwise, initialize it
    _database = await _initDatabase();
    return _database!;
  }

  // --------------------------------------------------------------
  // Open or create the database
  // --------------------------------------------------------------
  Future<Database> _initDatabase() async {
    // Get the app’s documents directory (safe, not cleared when app restarts)
    final directory = await getApplicationDocumentsDirectory();

    // Build a path to store our database file
    final path = join(directory.path, _dbName);

    // Open the database — if it doesn't exist, onCreate() runs
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // --------------------------------------------------------------
  // Create tables (runs once when DB is first created)
  // --------------------------------------------------------------
  Future<void> _onCreate(Database db, int version) async {
    // VEHICLE TABLE
    await db.execute('''
      CREATE TABLE $vehicleTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        make TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER,
        mileage REAL
      )
    ''');

    // MAINTENANCE LOG TABLE
    await db.execute('''
      CREATE TABLE $maintenanceTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        cost REAL,
        notes TEXT,
        FOREIGN KEY(vehicleId) REFERENCES $vehicleTable(id) ON DELETE CASCADE
      )
    ''');

    // REMINDERS TABLE
    await db.execute('''
      CREATE TABLE $reminderTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleId INTEGER NOT NULL,
        message TEXT NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY(vehicleId) REFERENCES $vehicleTable(id) ON DELETE CASCADE
      )
    ''');
  }

  // ======================================================================
  // VEHICLE CRUD OPERATIONS
  // ======================================================================

  // Insert a new vehicle record into the database
  Future<int> insertVehicle(Map<String, dynamic> vehicle) async {
    final db = await database;
    return await db.insert(vehicleTable, vehicle);
  }

  // Retrieve all vehicles (newest first)
  Future<List<Map<String, dynamic>>> getVehicles() async {
    final db = await database;
    return await db.query(vehicleTable, orderBy: 'id DESC');
  }

  // Update an existing vehicle’s details by ID
  Future<int> updateVehicle(int id, Map<String, dynamic> vehicle) async {
    final db = await database;
    return await db.update(vehicleTable, vehicle, where: 'id = ?', whereArgs: [id]);
  }

  // Delete a vehicle by ID
  Future<int> deleteVehicle(int id) async {
    final db = await database;
    return await db.delete(vehicleTable, where: 'id = ?', whereArgs: [id]);
  }

  // ======================================================================
  // MAINTENANCE LOG CRUD OPERATIONS
  // ======================================================================

  // Add a new maintenance log for a vehicle
  Future<int> insertMaintenance(Map<String, dynamic> maintenance) async {
    final db = await database;
    return await db.insert(maintenanceTable, maintenance);
  }

  // Get all maintenance logs for a specific vehicle
  Future<List<Map<String, dynamic>>> getMaintenanceByVehicle(int vehicleId) async {
    final db = await database;
    return await db.query(
      maintenanceTable,
      where: 'vehicleId = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',  // show latest logs first
    );
  }

  // Delete a maintenance record by ID
  Future<int> deleteMaintenance(int id) async {
    final db = await database;
    return await db.delete(maintenanceTable, where: 'id = ?', whereArgs: [id]);
  }

  // ======================================================================
  // REMINDER CRUD OPERATIONS
  // ======================================================================

  // Add a new reminder
  Future<int> insertReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    return await db.insert(reminderTable, reminder);
  }

  // Retrieve all reminders (soonest first)
  Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await database;
    return await db.query(reminderTable, orderBy: 'date ASC');
  }

  // Delete a reminder by ID
  Future<int> deleteReminder(int id) async {
    final db = await database;
    return await db.delete(reminderTable, where: 'id = ?', whereArgs: [id]);
  }
}

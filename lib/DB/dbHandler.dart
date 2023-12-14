import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Model/bookingModel.dart';
import '../Model/driverModel.dart';
import '../Model/expenseModel.dart';
import '../Model/vehicleModel.dart';

class DbHandler {
  DbHandler._();
  static DbHandler instance = DbHandler._();
  Future<Database> initDatabase() async {
    String dbpath = await getDatabasesPath();
    Database db = await openDatabase(
      version: 3,
      join(
        dbpath,
        'Vehicle.db',
      ),
      onCreate: (db, version) async {
        await db.execute(
            'create table Vehicle(vid INTEGER PRIMARY KEY AUTOINCREMENT, make TEXT, color TEXT, imagePath TEXT )');
        await db.execute(
            'create table Driver(did INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT,contact INTEGER,imagePath TEXT )');
        await db.execute('''
        CREATE TABLE Booking(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        driverId INTEGER,
        vehicleId INTEGER,
        city TEXT,
        totalCost REAL,
        FOREIGN KEY (driverId) REFERENCES Driver (ID),
        FOREIGN KEY (vehicleId) REFERENCES Vehicle (ID)
      )
    ''');

        await db.execute('''
      CREATE TABLE BookingExpense(
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        bookingId INTEGER,
        expenseType TEXT,
        city TEXT,
        amount REAL,
        FOREIGN KEY (bookingId) REFERENCES Booking (ID)
      )
    ''');
      },
    );
    return db;
  }

  Future<void> addVehicleRecord(VehicleModel vehile) async {
    Database db = await initDatabase();
    await db.insert('Vehicle', vehile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> addDriverRecord(DrivereModel driver) async {
    print('Driver Path ${driver.imagePath}');
    Database db = await initDatabase();
    await db.insert('Driver', driver.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<VehicleModel>> ShowVehicleRecords() async {
    Database db = await initDatabase(); //for connection
    List<Map<String, dynamic>> vehicleList = await db.query('Vehicle');
    List<VehicleModel> vlist = vehicleList
        .map((e) => VehicleModel(
            vid: e['vid'],
            color: e['color'],
            make: e['make'],
            imagePath: e['imagePath']))
        .toList();
    return vlist;
  }

  Future<List<DrivereModel>> ShowDriverRecords() async {
    Database db = await initDatabase(); //for connection
    List<Map<String, dynamic>> driverList = await db.query('Driver');
    List<DrivereModel> dlist = driverList
        .map((e) => DrivereModel(
            did: e['did'],
            Name: e['Name'],
            contact: e['contact'],
            imagePath: e['imagePath']))
        .toList();
    return dlist;
  }

  Future<void> delVehicleRecord(int vID) async {
    Database db = await initDatabase();
    await db.delete('Vehicle', where: 'vid=?', whereArgs: [vID]);
  }

  Future<void> updateVehicleRecords(int vID, VehicleModel veh) async {
    Database db = await initDatabase();
    await db.update('Vehicle', veh.toMap(), where: 'vid=?', whereArgs: [vID]);
  }

  Future<void> delDriverRecord(int dID) async {
    Database db = await initDatabase();
    await db.delete('Driver', where: 'did=?', whereArgs: [dID]);
  }

  Future<void> updateDriverRecords(int dID, DrivereModel driver) async {
    Database db = await initDatabase();
    await db.update('Driver', driver.toMap(), where: 'did=?', whereArgs: [dID]);
  }

  //Booking

  Future<int> insertBooking(BookingModel booking) async {
    Database db = await initDatabase();
    int rowId = await db.insert('Booking', booking.toMap());
    return rowId;
  }

  Future<int> updateBooking(BookingModel booking) async {
    Database db = await initDatabase();
    return await db.update('Booking', booking.toMap(),
        where: 'ID = ?', whereArgs: [booking.id]);
  }

  Future<int> deleteBooking(int id) async {
    Database db = await initDatabase();
    return await db.delete('Booking', where: 'ID = ?', whereArgs: [id]);
  }

  Future<List<BookingModel>> getAllBookings() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> rows = await db.query('Booking');
    List<BookingModel> bookingList = rows
        .map(
          (e) => BookingModel(
            id: e["ID"],
            driverId: e["driverId"],
            vehicleId: e["vehicleId"],
            city: e["city"],
          
            totalCost: e["totalCost"],
          ),
        )
        .toList();
    return bookingList;
  }

  //Other 2
  Future<int> insertBookingExpense(BookingExpense bookingExpense) async {
    Database db = await initDatabase();
    int rowId = await db.insert('BookingExpense', bookingExpense.toMap());
    return rowId;
  }

  Future<int> updateBookingExpense(BookingExpense bookingExpense) async {
    Database db = await initDatabase();
    return await db.update('BookingExpense', bookingExpense.toMap(),
        where: 'ID = ?', whereArgs: [bookingExpense.id]);
  }

  Future<int> deleteBookingExpense(int id) async {
    Database db = await initDatabase();
    return await db.delete('BookingExpense', where: 'ID = ?', whereArgs: [id]);
  }

  Future<List<BookingExpense>> getAllBookingExpenses() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> rows = await db.query('BookingExpense');
    List<BookingExpense> bookingExpenseList = rows
        .map(
          (e) => BookingExpense(
            id: e["ID"],
            bookingId: e["bookingId"],
            expenseType: e["expenseType"],
            amount: e["amount"],
          ),
        )
        .toList();
    return bookingExpenseList;
  }

  Future<List<Map<String, dynamic>>> getBookingReport() async {
    Database db = await initDatabase();
    return await db.rawQuery('''
    SELECT Booking.ID as bookingId, Driver.Name as driverName, Vehicle.make as vehicleMake,
    Booking.startTime, Booking.endTime, Booking.totalCost, BookingExpense.expenseType, BookingExpense.amount
    FROM Booking
    LEFT JOIN Driver ON Booking.driverId = Driver.did
    LEFT JOIN Vehicle ON Booking.vehicleId = Vehicle.vid
    LEFT JOIN BookingExpense ON Booking.ID = BookingExpense.bookingId
  ''');
  }
}

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:notekeeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //Singleton dbhelper object
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDesc = 'desc';
  String colDate = 'date';
  String colPriority = 'priority';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var noteDB = openDatabase(path, version: 1, onCreate: _createDb);
    return noteDB;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT , $colDesc TEXT , $colPriority INTEGER , $colDate TEXT)');
  }
  //fetch Notes from DB

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT *from $noteTable orger by $colPriority ASC');
    //OR
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  //Insert Operation

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //Update Operation
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  //Delete Operation
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  //to get total no of Notes from db
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get Map List List<Map> and Convert into Note List List<Note>
 Future<List<Note>> getNoteList() async {

		var noteMapList = await getNoteMapList(); // Get 'Map List' from database
		int count = noteMapList.length;         // Count the number of map entries in db table

		List<Note> noteList = List<Note>();
		// For loop to create a 'Note List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			noteList.add(Note.fromMapObject(noteMapList[i]));
		}
		return noteList;
	}
}

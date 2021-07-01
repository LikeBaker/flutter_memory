import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //不引用没有join方法

class DbHelper{

  late final Future<Database> database;

  //创建数据库
  Future<void> createDb() async {

    database = openDatabase(
      join(await getDatabasesPath(), 'memory.db'), //todo await 必须和async配合使用

      onCreate: (db, version) {
        // Run the CREATE TABLE statement.
        return db.execute(
            "CREATE TABLE memories (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, initDate TEXT, nextDate TEXT, isMemory INTEGER)");

      }, // Set the version to perform database upgrades and downgrades.
      version: 1,
    );
  }

  //插入一条数据
  Future<int> insertMemory(Memory memory) async {
    if (database == null) {
      log('database is null');
      return 0;
    }

    final Database db = await database;
    var insert = db.insert(
      'memories',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
     return await insert;

  }

  Future<int> insertOneMemory(String title, String content) async {
    print("insertOneMemory");

    // final b1 = Memory(id: 0, title: 'the title', content: "the content", initDate: "", nextDate:"", isMemory:0);
    final m = Memory(title, content, "", "", 0);

    return insertMemory(m);
  }

  Future<List<Memory>> getMemories() async {
    final Database db = await database;

    // Use query for all Memories.
    final List<Map<String, dynamic>> maps = await db.query('memories');

    return List.generate(maps.length, (i) {
      return Memory(maps[i]['title'], maps[i]['content'],
          maps[i]['initDate'], maps[i]['nextDate'], maps[i]['isMemory']);
    });
  }

  //根据id获取一条数据
  Future<List<Memory>> getMemory(int id) async {
    final Database db = await database;

    print("here1 $id");
    final List<Map<String, dynamic>> maps = await db.query('memories',
    where: 'title = ?',whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return Memory(maps[i]['title'], maps[i]['content'],
          maps[i]['initDate'], maps[i]['nextDate'], maps[i]['isMemory']);
    });;
  }
}

class Memory {
  final String title;
  final String content;
  final String initDate;
  final String nextDate;
  final int isMemory;

  Memory(this.title, this.content, this.initDate, this.nextDate,
      this.isMemory);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'initDate': initDate,
      'nextDate': nextDate,
      'isMemory': isMemory
    };
  }

  @override
  String toString() {
    return "title $title, content $content, initDate $initDate, nextDate $nextDate, isMemory $isMemory";
  }
}
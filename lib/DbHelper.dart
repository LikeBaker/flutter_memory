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

  /// 插入一条 [Memory]
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

  /// 插入一条数据，根据title和content生成[Memory]并写入数据库
  Future<int> insertOneMemory(String title, String content) async {

    // final b1 = Memory(id: 0, title: 'the title', content: "the content", initDate: "", nextDate:"", isMemory:0);
    final m = Memory(title, content, "", "", 0);

    return insertMemory(m);
  }

  ///获取所有的[Memory]记录
  Future<List<Memory>> getMemories() async {
    final Database db = await database;

    // Use query for all Memories.
    final List<Map<String, dynamic>> maps = await db.query('memories');

    return List.generate(maps.length, (i) {
      return Memory(maps[i]['title'], maps[i]['content'],
          maps[i]['initDate'], maps[i]['nextDate'], maps[i]['isMemory']);
    });
  }

  ///根据id获取一条[Memory]数据
  Future<List<Memory>> getMemory(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('memories',
    where: 'id = ?',whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return Memory(maps[i]['title'], maps[i]['content'],
          maps[i]['initDate'], maps[i]['nextDate'], maps[i]['isMemory']);
    });
  }

  Future<int> updateMemory(int id, String field, String value) async{
    final Database db = await database;
    // db.rawUpdate('UPDATE memories SET $field = $value WHERE id = $id');
    return db.rawUpdate('UPDATE memories SET $field = $value WHERE id = $id');//使用一个参数的方式也可以更新
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
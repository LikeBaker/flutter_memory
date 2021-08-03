import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //不引用没有join方法

class DbHelper{

  late final Future<Database> _database;

  //dart有一个factory关键字，factory修饰的默认构造函数要返回类型实例。其它构造函数不能返回实例。
  //工厂构造函数
  // factory DbHelper() => _getInstance();
  // static DbHelper get instance => _getInstance();

  // static DbHelper? _instance;

  // static Future<DbHelper?> get instance async{
  //   if(_instance != null){
  //     return _instance;
  //   }
  //
  //   return _getInstance();
  // }
  //
  DbHelper._internal() {
    _database = createDb();
  }

  static final _instance = DbHelper._internal();

  factory DbHelper(){
    return _instance;
  }

  Future get initializationDone => _database;

  // static DbHelper _getInstance() {
  //   if (_instance == null) {
  //     _instance = DbHelper._internal();
  //   }
  //
  //   return _instance!;
  // }

  //创建数据库
  Future<Database> createDb() async {

    // _database = openDatabase( //todo 这样写不能实现同步
    return openDatabase(
      join(await getDatabasesPath(), 'memory.db'), //todo await 必须和async配合使用

      onCreate: (db, version) {
        // Run the CREATE TABLE statement.
        return db.execute(
            "CREATE TABLE memories (id INTEGER PRIMARY KEY AUTOINCREMENT, title Text, content Text, initDate INTEGER, memoryCount INTEGER, isMemory INTEGER)");

      }, // Set the version to perform database upgrades and downgrades.
      version: 1,
    );
  }

  /// 插入一条 [Memory]
  Future<int> insertMemory(Memory memory) async {
    if (_database == null) {
      log('database is null');
      return 0;
    }

    final Database db = await _database;
    var insert = db.insert(
      'memories',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
     return await insert;

  }

  /// 插入一条数据，根据title和content生成[Memory]并写入数据库
  Future<int> insertOneMemory(String title, String content) async {

    // final b1 = Memory(id: 0, title: 'the title', content: "the content", initDate: "", memoryCount:"", isMemory:0);
    final m = Memory.generate(title, content, new DateTime.now().millisecondsSinceEpoch, 0, 0);

    return insertMemory(m);
  }

  ///获取所有的[Memory]记录
  Future<List<Memory>> getMemories() async {
    final Database db = await _database;

    // Use query for all Memories.
    final List<Map<String, dynamic>> maps = await db.query('memories');

    return List.generate(maps.length, (i) {
      return Memory(maps[i]['id'], maps[i]['title'], maps[i]['content'],
          maps[i]['initDate'], maps[i]['memoryCount'], maps[i]['isMemory']);
    });
  }

  ///根据id获取一条[Memory]数据
  Future<List<Memory>> getMemory(int id) async {
    final Database db = await _database;

    final List<Map<String, dynamic>> maps = await db.query('memories',
    where: 'id = ?',whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return Memory(maps[i]['id'], maps[i]['title'], maps[i]['content'],
          maps[i]['initDate'], maps[i]['memoryCount'], maps[i]['isMemory']);
    });
  }

  ///根据id修改记录，通过参数只当修改的字段和值
  Future<int> updateMemoryFlexible(int id, String field, String value) async{
    final Database db = await _database;
    // db.rawUpdate('UPDATE memories SET $field = $value WHERE id = $id');
    return db.rawUpdate('UPDATE memories SET $field = $value WHERE id = $id');//使用一个参数的方式也可以更新
  }

  ///根据id，更新title和content
  Future<int> updateMemory(int id, String title, String content) async{
    final Database db = await _database;
    // db.rawUpdate('UPDATE memories SET $field = $value WHERE id = $id');
    return db.rawUpdate('UPDATE memories SET title = ?, content = ? WHERE id = ?', [title, content, id]);//使用一个参数的方式也可以更新
  }

  void delMemory(int id) async{
    final Database db = await _database;
    Future<int> future = db.rawDelete('DELETE FROM memories WHERE id = $id');
    future.then((value) => print("delete $value"));
  }

  // 批量删除
  // DELETE FROM TestTable WHERE FIELD_NAME IN (1, 2, 4, 8)
  Future<int> delMemories(List ids) async{
    print("ids $ids");

    var _delIdsStr = "(";
    while(ids.isNotEmpty){
      if(_delIdsStr.length == 1){
        _delIdsStr = _delIdsStr + ids.removeLast().toString();
      } else {
        _delIdsStr = _delIdsStr + "," + ids.removeLast().toString();
      }
    }

    _delIdsStr = _delIdsStr + ")";

    print(_delIdsStr);

    final Database db = await _database;
    // Future<int> future = db.rawDelete('DELETE FROM memories WHERE id in $_delIdsStr');
    // future.then((value) => print("delete $value"));
    return db.rawDelete('DELETE FROM memories WHERE id in $_delIdsStr');
  }

  Future<int> memoryCountIncrease(int id, int lastCount) async{
    final Database db = await _database;
    // db.rawUpdate('UPDATE memories SET $field = $value WHERE id = $id');
    return db.rawUpdate('UPDATE memories SET memoryCount = ? WHERE id = ?', [++lastCount, id]);
  }
}

class Memory {
  int id = -1;
  final String title;
  final String content;
  final int initDate;
  final int memoryCount;
  final int isMemory;

  Memory(this.id, this.title, this.content, this.initDate, this.memoryCount,
      this.isMemory);

  Memory.generate(this.title, this.content, this.initDate, this.memoryCount,
      this.isMemory);



  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'initDate': initDate,
      'memoryCount': memoryCount,
      'isMemory': isMemory
    };
  }

  @override
  String toString() {
    return "id $id, title $title, content $content, initDate $initDate, memoryCount $memoryCount, isMemory $isMemory";
  }
}
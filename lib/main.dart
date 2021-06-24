import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //不引用没有join方法

Future<void> main() async {
  runApp(new MyApp());

  createDb();
  // insertOneMemory();
}

class MyApp extends StatelessWidget {
  var list = [
    ["排序", "冒泡排序，快速排序，选择排序，插入排序，希尔排序，堆排序"],
    ["栈", "栈内容"],
    ["队列", "队列内容"],
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'memory curve',
        theme: new ThemeData(
          primaryColor: Colors.lightBlue,
          primarySwatch: Colors.lightGreen,
        ),
        home: new Scaffold(
          //增加Scaffold后背景为白色，否则为黑
          appBar: new AppBar(
            title: new Text("memory"),
          ),
          body: new ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(32.0),
            itemCount: list.length,
            //列表项构造器
            itemBuilder: (BuildContext context, int index) {
              // return ListTile(title: Text('$index'));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list[index][0], style: TextStyle(fontSize: 18)),
                  Text(list[index][1])
                ],
              );
            },
            //分割器构造器
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.blue); //下划线
            },
            // itemExtent: 60,//可以控制高度
          ),
        ));
  }
}

late final Future<Database> database;

//创建数据库
Future<void> createDb() async {
  String databasesPath = await getDatabasesPath();

  // Database Path: /data/user/0/com.package.name/databases
  // String path = join(databasesPath, 'memory.db');
  //
  // Database database = await openDatabase(
  //   path,
  //   version: 1,
  //   onCreate: (Database db, int version) async {
  //     // 表格创建等初始化操作
  //     db.execute('CREATE TABLE memories (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  //   },
  //   onUpgrade: (Database db, int oldVersion, int newVersion) async {
  //     // 数据库升级
  //   },
  // );

  database = openDatabase(
    join(await getDatabasesPath(), 'memory.db'), //todo await 必须和async配合使用

    onCreate: (db, version) {
      print("onCreate");
      // Run the CREATE TABLE statement.
      return db.execute(
          "CREATE TABLE memories (id INTEGER PRIMARY KEY, title TEXT, content TEXT, initDate TEXT, nextDate TEXT, isMemory INTEGER)");

    }, // Set the version to perform database upgrades and downgrades.
    version: 1,
  );

  // insertOneMemory();
  var memory = await getMemory();
  for(int i=0; i<memory.length; i++) {
    print("memory " + memory[i].toString());
  }

}

//插入一条数据
Future<void> insertMemory(Memory memory) async {
  if (database == null) {
    log('database is null');
    return;
  }

  final Database db = await database;
  await db.insert(
    'memories',
    memory.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

void insertOneMemory() async {
  print("insertOneMemory");

  // final b1 = Memory(id: 0, title: 'the title', content: "the content", initDate: "", nextDate:"", isMemory:0);
  final m = Memory(0, 'the title', "the content", "", "", 0);

  await insertMemory(m);
}

//查询
Future<List<Memory>> getMemory() async {
  final Database db = await database;

  // Use query for all Memories.
  final List<Map<String, dynamic>> maps = await db.query('memories');

  return List.generate(maps.length, (i) {
    return Memory(maps[i]['id'], maps[i]['title'], maps[i]['content'],
        maps[i]['initDate'], maps[i]['nextDate'], maps[i]['isMemory']);
  });
}

class Memory {
  final int id;
  final String title;
  final String content;
  final String initDate;
  final String nextDate;
  final int isMemory;

  Memory(this.id, this.title, this.content, this.initDate, this.nextDate,
      this.isMemory);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'initDate': initDate,
      'nextDate': nextDate,
      'isMemory': isMemory
    };
  }

  @override
  String toString() {
    return "id $id, title $title, content $content, initDate $initDate, nextDate $nextDate, isMemory $isMemory";
  }
}

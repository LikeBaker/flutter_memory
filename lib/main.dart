import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; //不引用没有join方法

Future<void> main() async {
  runApp(new MyApp());

  refreshData();
}

Future<void> refreshData() async {
  await createDb();
  var memory = await getMemory();
  for(int i=0; i<memory.length; i++) {
    list.add(memory[i]);
    print(memory[i].toString());
  }

  // ignore: invalid_use_of_protected_member
  memoryState.setState(() { });
}

// var list = [];
var list = <Memory>[];

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'memory curve',
        theme: new ThemeData(
          primaryColor: Colors.lightBlue,
          primarySwatch: Colors.lightGreen,
        ),
        home: MyHomePage());
  }
}

var memoryState = _MyMemories();
class MyHomePage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return  memoryState;
  }
}

//封装的页面动态类
class _MyMemories extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

      return Scaffold(

        //增加Scaffold后背景为白色，否则为黑
        appBar: new AppBar(
          title: new Text("memory"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: (){
            insertOneMemory("insert title", "insert content");
          },
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
                Text(list[index].title, style: TextStyle(fontSize: 18)),
                Text(list[index].content)
                // Text(index.toString(), style: TextStyle(fontSize: 18)),
                // Text(index.toString())
              ],
            );
          },
          //分割器构造器
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: Colors.blue); //下划线
          }
          // itemExtent: 60,//可以控制高度
        ),
      );
  }

  // @override
  // Future<void> setState(VoidCallback fn) async {//todo如何触发更新
  //   super.setState(fn);
  //   var memory = await getMemory();
  //   for(int i=0; i<memory.length; i++) {
  //     list.add(memory[i]);
  //     print(memory[i].toString());
  //   }
  // }
}

late final Future<Database> database;

//创建数据库
Future<void> createDb() async {

    database = openDatabase(
      join(await getDatabasesPath(), 'memory.db'), //todo await 必须和async配合使用

      onCreate: (db, version) {
        print("onCreate");
        // Run the CREATE TABLE statement.
        return db.execute(
            "CREATE TABLE memories (id INTEGER identity(1,1) PRIMARY KEY, title TEXT, content TEXT, initDate TEXT, nextDate TEXT, isMemory INTEGER)");

      }, // Set the version to perform database upgrades and downgrades.
      version: 1,
    );

  // insertOneMemory();
  // var memory = await getMemory();
  // list = <Memory>[];
  // for(int i=0; i<memory.length; i++) {
  //   list.add(memory[i]);
  //   print(memory[i].toString());
  // }
  //
  // memoryState.setState(() { });

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

void insertOneMemory(String title, String content) async {
  print("insertOneMemory");

  // final b1 = Memory(id: 0, title: 'the title', content: "the content", initDate: "", nextDate:"", isMemory:0);
  final m = Memory(title, content, "", "", 0);

  await insertMemory(m);
}

//查询
Future<List<Memory>> getMemory() async {
  final Database db = await database;

  // Use query for all Memories.
  final List<Map<String, dynamic>> maps = await db.query('memories');

  return List.generate(maps.length, (i) {
    return Memory(maps[i]['title'], maps[i]['content'],
        maps[i]['initDate'], maps[i]['nextDate'], maps[i]['isMemory']);
  });
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

import 'package:flutter/material.dart';
import 'package:flutter_memory/DbHelper.dart';

main() {
  runApp(new MyApp());

  refreshData();
}

var dbHelper = DbHelper();

Future<void> refreshData() async {
  await dbHelper.createDb();
  var memory = await dbHelper.getMemory();
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
            dbHelper.insertOneMemory("insert title", "insert content");
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

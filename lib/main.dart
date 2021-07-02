import 'package:flutter/material.dart';
import 'package:flutter_memory/DbHelper.dart';

main() async {
  runApp(new MyApp());

  await dbHelper.createDb();
  refreshData();
}

var dbHelper = DbHelper();

Future<void> refreshData() async {
  var memory = await dbHelper.getMemories();
  for (int i = 0; i < memory.length; i++) {
    list.add(memory[i]);
    print(memory[i].toString());
  }

  // ignore: invalid_use_of_protected_member
  memoryState.setState(() {});
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

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return memoryState;
  }
}

//封装的页面动态类
class _MyMemories extends State<MyHomePage> {
  //1.声明控件
  TextEditingController inputTitleController = TextEditingController();
  TextEditingController inputContentController = TextEditingController();

  var inputTitle, inputContent;

  @override
  Widget build(BuildContext context) {
    inputTitleController.addListener(() {
      inputTitle = inputTitleController.text;
    });

    inputContentController.addListener(() {
      inputContent = inputContentController.text;
    });

    return Scaffold(

        //增加Scaffold后背景为白色，否则为黑
        appBar: new AppBar(
          title: new Text("memory"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            print('onPressed');
            // dbHelper.insertOneMemory("insert title", "insert content");
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('add a memory'),
                    content: Column(mainAxisSize: MainAxisSize.min, //自适应高度
                        children: [
                          TextField(
                              controller: inputTitleController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: 'title',
                                  helperText: '请输入title',
                                  prefixIcon: Icon(Icons.person))),
                          TextField(
                              controller: inputContentController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: 'content',
                                  helperText: '请输入content',
                                  prefixIcon: Icon(Icons.person))),
                        ]),
                    actions: [
                      TextButton(
                          onPressed: () {
                            var insertOneMemory = dbHelper.insertOneMemory(
                                inputTitle, inputContent);
                            insertOneMemory.then((value) {
                              var memory = dbHelper.getMemory(value);
                              return {
                                print("插入成功"),
                                print("memory $memory"),
                                memory.then((value) => {
                                      memoryState.setState(() {
                                        print("set State $value");
                                        list.add(value[0]);
                                      }),
                                      Navigator.pop(context)
                                    })
                              };
                            });
                            //     .catchError((){
                            //   print("插入失败");
                            // }
                            // );
                          },
                          child: Text('确定')),
                      TextButton(
                          onPressed: () => {
                                Navigator.pop(context),
                                memoryState.setState(() {})
                              },
                          child: Text('取消'))
                    ],
                  );
                });
          },
        ),
        body: new ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(32.0),
            itemCount: list.length,
            //列表项构造器
            itemBuilder: (BuildContext context, int index) {
              // return ListTile(title: Text('$index'));
              return new GestureDetector(
                onTap: (){
                  print("click item $index");
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: Text("是否要修改"),
                      actions: [TextButton(
                          onPressed: () {
                            var id = list[index].id;
                            dbHelper.delMemory(id);
                            // var updateMemory = dbHelper.updateMemory(id,
                            //     "content", "1.4");
                            // updateMemory.then((value) {
                            //   var memory = dbHelper.getMemory(1);
                            //   return {
                            //   print("update result $value"),
                            //   memory.then((value) => {
                            //     memoryState.setState(() {
                            //       list[index] = value[0];
                            //     }),
                            //     Navigator.pop(context)
                            //   })
                            // };
                            // });
                            // print("update db");
                            //todo 更新成功后刷新页面
                          },
                          child: Text('确定')),],
                    );
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list[index].title, style: TextStyle(fontSize: 18)),
                    Text(list[index].content)
                    // Text(index.toString(), style: TextStyle(fontSize: 18)),
                    // Text(index.toString())
                  ],
                )
              );
            },
            //分割器构造器
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.blue); //下划线
            }
            // itemExtent: 60,//可以控制高度
            ));
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

import 'package:flutter/material.dart';
import 'package:flutter_memory/DbHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_memory/Edit.dart';

main() async {
  // runApp(new MemoryApp());
  runApp(new MaterialApp(title: "Memory App", home: new MemoryHome()));

  await dbHelper.createDb();
  refreshData();
}

var dbHelper = DbHelper();

// var list = [];
var list = <Memory>[];
var memoryState = new _MyMemories();

Future<void> refreshData() async {
  var memory = await dbHelper.getMemories();
  for (int i = 0; i < memory.length; i++) {
    var m = memory[i];
    print(m.toString());
    // if (isShow(m)) {
    //   list.add(m);
    // }
    list.add(m);
  }

  // ignore: invalid_use_of_protected_member
  memoryState.setState(() {});
}

class MemoryHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('The Memories'), actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.bookmark_added_outlined),
          tooltip: 'Search',
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditPage()),
        )),
      ]),
      body: new MyHomePage(),
    );
  }
}

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

    var listView = new ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        itemCount: list.length,
        //列表项构造器
        itemBuilder: (BuildContext context, int index) {
          // return ListTile(title: Text('$index'));
          var memoryContentText = Text(list[index].content);

          //markdown widget
          var markdownWidget = Markdown(data: list[index].content);
          // var markdownText = "扩展函数可以在已有类中添加新的方法，不会对原类进行修改，扩展函数定义形式\n\n```fun receiverType.functionName(params){    body  }```";
          // var markdownWidget = Markdown(
          //     data: markdownText,
          //     listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start);

          return new GestureDetector(
              behavior: HitTestBehavior.opaque,
              //点击范围约束，这样点击范围就是整个ListView的item，同时也不用设置背景
              onTap: () {
                print("click item $index");

                var id = list[index].id;
                var count = list[index].memoryCount;
                print("increase $id $count");
                var update = dbHelper.memoryCountIncrease(id, count);
                update.then((value) => {
                      // print("update result $value"),
                      if (value == 1)
                        {
                          memoryState.setState(() {
                            list.removeAt(index);
                          })
                        }
                    });

                // showDialog(context: context, builder: (context) {
                //   return AlertDialog(
                //     title: Text("是否要修改"),
                //     actions: [TextButton(
                //         onPressed: () {
                //           var id = list[index].id;
                //           //删除
                //           // dbHelper.delMemory(id);
                //           //更新
                //           // var updateMemory = dbHelper.updateMemory(id,
                //           //     "content", "1.4");
                //           // updateMemory.then((value) {
                //           //   var memory = dbHelper.getMemory(1);
                //           //   return {
                //           //   print("update result $value"),
                //           //   memory.then((value) => {
                //           //     memoryState.setState(() {
                //           // 更新成功后刷新页面
                //           //       list[index] = value[0];
                //           //     }),
                //           //     Navigator.pop(context)
                //           //   })
                //           // };
                //           // });
                //           // print("update db");
                //         },
                //         child: Text('确定')),
                //     ],
                //   );
                // });
              },
              onLongPress: () {
                //修改item
                print("long press item $index");
                int id = list[index].id;
                String title = list[index].title;
                String content = list[index].content;

                TextEditingController inputEditTitleController =
                    TextEditingController();
                TextEditingController inputEditContentController =
                    TextEditingController();

                inputEditTitleController.addListener(() {
                  title = inputEditTitleController.text;
                });

                inputEditContentController.addListener(() {
                  content = inputEditContentController.text;
                });

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("修改 Memory"),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                  controller: inputEditTitleController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: title,
                                      prefixIcon: Icon(Icons.person))),
                              TextField(
                                  controller: inputEditContentController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: content,
                                      prefixIcon: Icon(Icons.person))),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                //更新
                                if (title.length == 0) {
                                  title = "\'\'";
                                }

                                if (content.length == 0) {
                                  content = "\'\'";
                                }

                                var updateMemory =
                                    dbHelper.updateMemory(id, title, content);
                                updateMemory.then((value) {
                                  var memory = dbHelper.getMemory(id);
                                  return {
                                    print("update result $value"), //1为更新成功
                                    memory.then((value) => {
                                          memoryState.setState(() {
                                            // 更新成功后刷新页面
                                            if (value.length > 0) {
                                              list[index] = value[0];
                                            }
                                          }),
                                          Navigator.pop(context)
                                        })
                                  };
                                });
                                print("update db");
                              },
                              child: Text('确定')),
                        ],
                      );
                    });
              },
              // child: Container(
              //   height: 200,
              //   child: Markdown(
              //     data: "Mark down",
              //   ),
              // ),
              child: Container(
                  height: 175.0,
                  width: double.maxFinite,
                  // color: Colors.white,//限定最大宽度，且不设备背景，点击事件范围仅仅是有文字的区域
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IntrinsicHeight(
                      //     child:Column(
                      Column(children: [
                        Text(list[index].title, style: TextStyle(fontSize: 18)),
                        // memoryContentText,
                        // Expanded(
                        //     child: markdownWidget
                        Container(
                          height: 150,
                          color: Colors.lightBlueAccent,
                          child: markdownWidget,
                        )
                        // )
                      ]
                          // )

                          // Text(index.toString(), style: TextStyle(fontSize: 18)),
                          // Text(index.toString())
                          )
                    ],
                  )));
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.blue); //下划线
        }
        // itemExtent: 60,//可以控制高度
        );

    return Scaffold(

        //增加Scaffold后背景为白色，否则为黑

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
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
                              maxLines: 3,
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
                                      Fluttertoast.showToast(
                                          msg: "已加入记忆栈",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0),
                                      // memoryState.setState(() {
                                      //   print("set State $value");
                                      //   list.add(value[0]);
                                      // }),
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
        body: listView
        // Markdown(data: 'markdown data')
        );
  }
}

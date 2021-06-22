import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
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

                  Text(list[index][0],style: TextStyle(fontSize: 18)),
                  Text(list[index][1])
                ],
              );
            },
            //分割器构造器
            separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.blue);//下划线
            },
            // itemExtent: 60,//可以控制高度
          ),
        ));
  }
}

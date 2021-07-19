import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'DbHelper.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  var dbHelper;

  _EditPageState() {
    init();
  }

  void init() async {
    dbHelper = DbHelper();
    await dbHelper.initializationDone;
    refreshData();
  }

  var _list = <Memory>[];

  Future<void> refreshData() async {
    var memory = await dbHelper.getMemories();
    for (int i = 0; i < memory.length; i++) {
      var m = memory[i];
      print(m.toString());
      // if (isShow(m)) {
      //   list.add(m);
      // }
      _list.add(m);
    }

    setState(() {});
    // ignore: invalid_use_of_protected_member
    print("edit refresh");
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(color: Colors.grey);
    //必须要放在一个方法里
    var ls = new ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var title =
          Row(children: [
              Checkbox(onChanged:null, value: true),
              Container
          (
              padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(_list[index].title))
          ]);

          // var markdownWidget = Markdown(data: _list[index].content);
          var markdownWidget = MarkdownBody(
          data: _list[index]
              .content); //这里使用MarkdownBody，可以自适应高度，否则Markdown必须指定高度
          return new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          title,
          //mark widget 必须包裹一层
          // Stack(
          //   children: [
          Container(
          padding: EdgeInsets.all(16.0), alignment: Alignment.centerLeft,
          color: Colors.lightBlueAccent,
          // child: markdownWidget,
          child: markdownWidget,
          )
          // ],
          // )
          ]
          ,
          );
        },
        separatorBuilder: (context, index) => divider,
        itemCount: _list.length);

    return Scaffold(appBar: AppBar(title: Text('编辑')), body: ls);
  }
}

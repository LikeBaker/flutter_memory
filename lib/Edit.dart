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
  var checks;

  Future<void> refreshData() async {
    var memory = await dbHelper.getMemories();
    for (int i = 0; i < memory.length; i++) {
      var m = memory[i];
      // print(m.toString());
      // if (isShow(m)) {
      //   list.add(m);
      // }
      _list.add(m);
    }

    checks = List.filled(_list.length, false);

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
          var title = Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.topLeft,
              color: Colors.pink,
              child: Text(_list[index].title));
          // var markdownWidget = Markdown(data: _list[index].content);
          //这里使用MarkdownBody，可以自适应高度，否则Markdown必须指定高度
          // var markdownWidget = MarkdownBody(data: _list[index].content);
          var markdownWidget = MarkdownBody(data: _list[index].content);
          var memories = Row(crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    onChanged: (value) => {
                          print("$index $value"),
                          checks[index] = value!,
                          //需要再调用一下刷新，todo 是否可优化
                          setState(() {})
                        },
                    value: checks[index]),
                Expanded(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      title,
                      Container(
                          // width: 100,
                          // height: 100,
                          padding: EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          color: Colors.lightBlueAccent,
                          child: markdownWidget)
                    ]))
              ]);
          return memories;
        },
        separatorBuilder: (context, index) => divider,
        itemCount: _list.length);

    void deleteMemories(){
      print(checks);
      // checks.
      dbHelper.delMemories();
    }

    return new Scaffold(
      appBar: AppBar(title: Text("edit page")),
      body: Column(children: [Expanded(child: ls),
        MaterialButton(minWidth:double.infinity, height:45, color:Colors.redAccent, textColor:Colors.white, child: Text("删除"),
            disabledColor: Colors.grey,
            onPressed: checks != null && checks.contains(true) ? deleteMemories : null),
      ])
    );


  }
}

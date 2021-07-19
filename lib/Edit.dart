import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DbHelper.dart';

class EditPage extends StatelessWidget{

  var dbHelper;

  EditPage() {
    init();
  }

  void init() async{
    dbHelper = DbHelper();
    await dbHelper.initializationDone;
    refreshData();
  }

  var list = <Memory>[];

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
    print("edit refresh");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title:Text('编辑'))
    );
  }
}
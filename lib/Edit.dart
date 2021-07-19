import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DbHelper.dart';

class EditPage extends StatelessWidget{

  var dbHelper;

  EditPage() {
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title:Text('编辑'))
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'memory curve',
      theme: new ThemeData(
        primaryColor: Colors.lightBlue,
        primarySwatch: Colors.lightGreen,
      ),
      home: new Scaffold(//增加Scaffold后背景为白色，否则为黑
        appBar: new AppBar(
          title: new Text("memory"),

        ),
        body: new ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(32.0),
            itemBuilder : (BuildContext context, int index) {
              return ListTile(title: Text('$index'));
            },
            itemCount : 100,
            itemExtent: 35,
        ),
      )
    );
  }

}

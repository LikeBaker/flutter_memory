import 'package:flutter_memory/DbHelper.dart';

var dbHelper;

MemoryData() async {
  dbHelper = DbHelper();
  await dbHelper.initializationDone;
  print("here1");
}


/// 获取到所有的Memory
Future<List<Memory>> getMemories() async {
  // DbHelper()
  //     .getMemories()
  //     .then((value) => {print("获取所有Memory记录"), print(value.toString())});

  return await DbHelper().getMemories();
}

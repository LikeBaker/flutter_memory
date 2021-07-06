
import 'DbHelper.dart';

const int DAYTIME = 24*60*60*1000;

/// 根据日期计算是否显示
/// 记忆周期：1天 2天 4天 7天 15天 1个月 3个月 6个月
bool isShow(Memory m){

  int date = m.initDate;
  int count = m.memoryCount;

  var currentTimeStamp = new DateTime.now().millisecondsSinceEpoch;

  var timeDiff = currentTimeStamp - date;
  var quotient = timeDiff / DAYTIME;
  if(quotient >= 1 && quotient < 2 && count == 0) {
    print("here1");
    return true;
  } else if(quotient >= 2 && quotient < 4 && count <= 1) {
    print("here2");
    return true;
  } else if(quotient >= 4 && quotient < 7 && count <= 2){
    print("here3");
    return true;
  } else if(quotient >= 7 && quotient < 15 && count <= 3) {
    print("here4");
    return true;
  } else if(quotient >= 15 && quotient < 30 && count <= 4) {
    print("here5");
    return true;
  } else if(quotient >= 30 && quotient < 90 && count <= 5) {
    print("here6");
    return true;
  } else if(quotient >=90 && quotient < 180 && count <= 6) {
    print("here7");
    return true;
  } else {
    print("here8");
    return false;
  }

}
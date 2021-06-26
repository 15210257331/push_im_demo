import 'package:intl/intl.dart';

class DateUtils {
  // 根据时间戳转换成固定格式时间
  static String timestampToLocalDateYMD(int timestamp) {
    if(timestamp == null) return '';
    DateTime date =   DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('HH:mm:ss').format(date);
  }
}



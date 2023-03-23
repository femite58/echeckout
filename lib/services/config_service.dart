import 'dart:math' as math;

class ConfigService {
  static const baseUrl = 'https://api.pavypay.com/api/';

  static String cardNoDecrypt(String str) {
    String normalStr = '';
    for (int i = 12; i < str.length; i += 16) {
      if (i != 60) {
        normalStr += str.substring(i, i + 4);
      } else {
        String last = str.substring(i);
        normalStr +=
            last.substring(last.length - last.length, last.length - 12);
        break;
      }
    }
    List s = ['P', 'Y', 'G', 'M', 'D', 'Q', 'F', 'N', 'O', 'X'];
    List r = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    for (int i = 0; i < s.length; i++) {
      String ea = s[i];
      normalStr = normalStr.replaceAll(RegExp(ea), r[i]);
    }
    return normalStr;
  }

  static String cvvDecrypt(String cvv) {
    String convStr = '';
    for (int i = 18; i < cvv.length; i += 19) {
      convStr += cvv.substring(i, i + 1);
    }
    List s = ['R', 'U', 'S', 'I', 'Z', 'T', 'C', 'V', 'W', 'E'];
    List r = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    for (int i = 0; i < s.length; i++) {
      String ea = s[i];
      convStr = convStr.replaceAll(RegExp(ea), r[i]);
    }
    return convStr;
  }

  static String randStr(int num) {
    String retstr = '';
    for (int i = 0; i < num; i++) {
      retstr += '${math.Random().nextInt(10)}';
    }
    return retstr;
  }
}

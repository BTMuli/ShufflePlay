// Dart imports:
import 'dart:math';

/// 随机字符串类型枚举
enum RandomStringType {
  /// hex
  hex,

  /// 大写数字&字母
  upper,

  /// 小写数字&字母
  lower,

  /// 数字
  number,

  /// 字母
  letter,

  /// 全部
  all,
}

/// 根据输入的长度和类型生成随机字符串
String genRandomStr(
  int length, {
  RandomStringType type = RandomStringType.all,
  int min = 0,
  int max = 0,
}) {
  var random = Random();
  var buffer = StringBuffer();
  for (var i = 0; i < length; i++) {
    switch (type) {
      case RandomStringType.hex:
        buffer.write(random.nextInt(16).toRadixString(16));
        break;
      case RandomStringType.upper:
        buffer.write(String.fromCharCode(random.nextInt(26) + 65));
        break;
      case RandomStringType.lower:
        buffer.write(String.fromCharCode(random.nextInt(26) + 97));
        break;
      case RandomStringType.number:
        if (min != 0 && max != 0) {
          buffer.write(random.nextInt(max - min) + min);
        } else {
          buffer.write(String.fromCharCode(random.nextInt(10) + 48));
        }
        break;
      case RandomStringType.letter:
        buffer.write(String.fromCharCode(random.nextInt(26) + 65));
        break;
      case RandomStringType.all:
        var type = random.nextInt(3);
        switch (type) {
          case 0:
            buffer.write(String.fromCharCode(random.nextInt(26) + 65));
            break;
          case 1:
            buffer.write(String.fromCharCode(random.nextInt(26) + 97));
            break;
          case 2:
            buffer.write(String.fromCharCode(random.nextInt(10) + 48));
            break;
        }
        break;
    }
  }
  return buffer.toString();
}

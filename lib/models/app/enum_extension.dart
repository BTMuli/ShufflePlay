// Dart imports:
import 'dart:ui';

int floatToInt8(double x) {
  return (x * 255.0).round() & 0xff;
}

extension ColorExtension on Color {
  int get hex =>
      floatToInt8(a) << 24 |
      floatToInt8(r) << 16 |
      floatToInt8(g) << 8 |
      floatToInt8(b) << 0;
}

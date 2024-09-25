

import 'package:smartenergy_app/api/utils.dart';

void main() {
  String serial = "2024-0917-AAAA";
  String serial2 = getFromEighthDigit(serial);
  print(serial2);
}
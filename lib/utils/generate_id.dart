import 'package:hive_flutter/hive_flutter.dart';

int generateId(Box box) {
  return box.isEmpty ? 1 : box.values.last.id + 1;
}

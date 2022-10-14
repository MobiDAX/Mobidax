import 'package:flutter/material.dart';

colorHelper(String str) {
  return str.contains('+') ? Colors.green : Colors.red;
}

takerTypeColorHelper(String str) {
  return str.contains('buy') ? Colors.green : Colors.red;
}

toHex(Color color) {
  return "#${color.value.toRadixString(16).split('ff')[1]}";
}

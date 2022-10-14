import 'package:flutter/material.dart';

toHex(Color color) {
  return "#${color.value.toRadixString(16).split('ff')[1]}";
}

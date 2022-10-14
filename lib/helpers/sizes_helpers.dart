import 'package:flutter/material.dart';

// Screen size with both dimensions
Size displaySize(BuildContext context) {
  return MediaQuery.of(context).size;
}

// Screen display height not counting the appbar and phone header
double displayHeight(BuildContext context) {
  return displaySize(context).height;
}

// Screen width not counting any buttons etc.
double displayWidth(BuildContext context) {
  return displaySize(context).width;
}

bool isDesktop(BuildContext context) {
  return displayWidth(context) > 720.0 ? true : false;
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

const Map<String, String> documentTypes = {
  'Passport': 'Passport',
  'Identity card': 'Identity card',
  'Driver license': 'Driver license',
  'Utility Bill': 'Utility Bill',
  'Residental': 'Residental',
  'Institutional': 'Institutional',
};

const supportedLocales = [
  Locale('en', 'US'),
];

Map<String, dynamic> barongLabels = {
  'email': {
    'value': 'verified',
    'translation': tr('email'),
    'icon': Icons.mail_outline
  },
  'phone': {
    'value': 'verified',
    'translation': tr('phone'),
    'path': '/accountAddPhone',
    'icon': Icons.phone
  },
  'document': {
    'value': 'verified',
    'translation': tr('profile'),
    'path': '/accountVerifyIdentity',
    'icon': Icons.person
  },
};

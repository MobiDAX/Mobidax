import 'package:easy_localization/easy_localization.dart';

enum orderSide { buy, sell }
enum orderType { market, limit }
enum Status { success, error }
final Map<String, int> periods = {
  '1${tr('minute')}': 1,
  '5${tr('minute')}': 5,
  '15${tr('minute')}': 15,
  '30${tr('minute')}': 30,
  '1${tr('hour')}': 60,
  '2${tr('hour')}': 120,
  '4${tr('hour')}': 240,
  '6${tr('hour')}': 360,
  '12${tr('hour')}': 720,
  '1${tr('day')}': 1440,
  '3${tr('day')}': 4320
};

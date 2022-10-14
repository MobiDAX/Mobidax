import 'package:intl/intl.dart';

volumeHelper(double volume, String volumeId) {
  var _formattedNumber = volume > 999
      ? NumberFormat.compact().format(volume.round())
      : volume.toStringAsFixed(2);

  return "$_formattedNumber" + " " + volumeId.toUpperCase();
}

toStringWithPrecision(double num, int precision) {
  var _decimalPart = num.toString().split('.')[1].substring(0, precision);
  var _intPart = num.toString().split('.')[0];
  return "$_intPart.$_decimalPart";
}

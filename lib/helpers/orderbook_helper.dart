import 'package:easy_localization/easy_localization.dart';
import 'package:mobidax_redux/redux.dart';

double orderWidthHelper(OrderbookState orderbook, double amount) {
  var askMaxVolume = 0.0;
  var bidMaxVolume = 0.0;

  orderbook.asks.forEach((element) {
    askMaxVolume += element.amount;
  });

  orderbook.bids.forEach((element) {
    bidMaxVolume += element.amount;
  });

  var maxVolume = askMaxVolume > bidMaxVolume ? askMaxVolume : bidMaxVolume;
  return amount / maxVolume;
}

formatNumber(number, decimalDigits) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: decimalDigits,
  ).format(number);
}

double maxVolume(OrderbookState orderbook) {
  var askMaxVolume = 0.0;
  var bidMaxVolume = 0.0;

  orderbook.asks.forEach(
    (element) {
      askMaxVolume += element.amount;
    },
  );

  orderbook.bids.forEach(
    (element) {
      bidMaxVolume += element.amount;
    },
  );

  var maxVolume = askMaxVolume > bidMaxVolume ? askMaxVolume : bidMaxVolume;
  return maxVolume;
}

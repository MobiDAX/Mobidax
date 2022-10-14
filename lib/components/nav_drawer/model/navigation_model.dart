import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NavigationModel {
  NavigationModel({
    this.title,
    this.icon,
  });

  String title;
  IconData icon;
}

List<NavigationModel> navigationItems = [
  NavigationModel(
    title: tr('exchange_tab'),
    icon: Icons.compare_arrows,
  ),
  NavigationModel(
    title: tr('funds_tab'),
    icon: Icons.account_balance_wallet,
  ),
  NavigationModel(
    title: tr('account_tab'),
    icon: Icons.account_circle,
  ),
  NavigationModel(
    title: tr('history_tab_label'),
    icon: Icons.history,
  ),
];

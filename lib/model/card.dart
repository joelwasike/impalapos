import 'package:flutter/material.dart';

class Cardd {
  final String logo;
  final String number;
  final String title;
  final String plan;
  final List<Color> color;
  final String currency;
  final String currencycode;

  const Cardd({
    required this.logo,
    required this.number,
    required this.title,
    required this.plan,
    required this.color,
    required this.currency,
    required this.currencycode,
  });
}

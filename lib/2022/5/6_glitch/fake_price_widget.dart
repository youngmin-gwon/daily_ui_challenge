import 'dart:async';

import 'package:flutter/material.dart';

import 'currency.dart';

class FakePriceChangeWidget extends StatefulWidget {
  const FakePriceChangeWidget({Key? key, required this.builder})
      : super(key: key);

  final Widget Function(BuildContext context, Usd price) builder;

  @override
  State<FakePriceChangeWidget> createState() => _FakePriceChangeWidgetState();
}

class _FakePriceChangeWidgetState extends State<FakePriceChangeWidget> {
  static const _prices = [
    Usd.fromCents(4013042),
    Usd.fromCents(4018634),
    Usd.fromCents(4018716),
    Usd.fromCents(4010211),
    Usd.fromCents(4020359),
    Usd.fromCents(3999646),
    Usd.fromCents(4029080),
    Usd.fromCents(4017045),
    Usd.fromCents(4012737),
    Usd.fromCents(4026222),
    Usd.fromCents(4021498),
    Usd.fromCents(4022052),
    Usd.fromCents(4014613),
    Usd.fromCents(4019625),
    Usd.fromCents(3999742),
    Usd.fromCents(4048220),
  ];

  int _priceIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), _shake);
  }

  void _shake() {
    if (mounted) {
      setState(() {
        _priceIndex = (_priceIndex + 1) % _prices.length;
      });

      Timer(const Duration(milliseconds: 1500), _shake);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _prices[_priceIndex]);
  }
}

import 'package:intl/intl.dart';

class Usd implements Comparable<Usd> {
  static final _currencyFormat = NumberFormat.currency(
    symbol: "\$",
    decimalDigits: 2,
  );

  const Usd.fromCents(int cents) : _inCents = cents;

  const Usd.fromDollarsAndCents({
    required int dollars,
    required int cents,
  }) : _inCents = (dollars * 100) + cents;

  final int _inCents;

  int get dollars => _inCents ~/ 100;
  int get cents => _inCents % 100;
  int get inCents => _inCents;

  /// Returns the total value of this USD, as a dollar fraction, e.g.,
  /// `Usd.FromCents(11530).asFraction`=> `115.30`.
  double get asFraction => dollars + (cents / 100);

  /// Returns the value of this USD, as a traditionally formatted
  /// currency value, e.g., "$1,234.56"
  String toFormattedString() => _currencyFormat.format(asFraction);

  bool operator <(Usd other) => _inCents < other._inCents;
  bool operator >(Usd other) => _inCents > other._inCents;

  @override
  int compareTo(Usd other) => _inCents.compareTo(other._inCents);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usd &&
          runtimeType == other.runtimeType &&
          _inCents == other._inCents;

  @override
  int get hashCode => _inCents.hashCode;
}

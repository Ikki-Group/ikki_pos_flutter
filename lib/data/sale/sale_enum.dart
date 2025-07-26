enum SaleMode {
  dineIn(value: 'Dine-in'),
  takeAway(value: 'Take Away');

  const SaleMode({required this.value});
  final String value;

  @override
  String toString() => value;

  static SaleMode fromString(String value) {
    return values.firstWhere((e) => e.value == value);
  }
}

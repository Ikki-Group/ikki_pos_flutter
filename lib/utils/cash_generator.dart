import 'package:fpdart/fpdart.dart';

abstract class CashPaymentGenerator {
  static const List<int> defaultDenominations = [
    5000,
    10000,
    20000,
    50000,
    100000,
  ];

  /// Generate nearest/possible cash payment options
  static List<int> generateCashOptions(
    int totalAmount, {
    List<int> denominations = defaultDenominations,
  }) {
    final options = <int>{};

    // Always include exact amount if it can be made with available denominations
    if (canMakeExactAmount(totalAmount, denominations)) {
      options.add(totalAmount);
    }

    // Find the smallest denomination that's >= total amount
    final nextLarger = denominations
        .where((denom) => denom >= totalAmount)
        .fold<int?>(
          null,
          (prev, current) => prev == null || current < prev ? current : prev,
        );

    if (nextLarger != null) {
      options.add(nextLarger);
    }

    // Add some convenient larger amounts
    final convenientAmounts = [
      ((totalAmount / 10000).ceil() * 10000), // Round up to nearest 10k
      ((totalAmount / 50000).ceil() * 50000), // Round up to nearest 50k
      ((totalAmount / 100000).ceil() * 100000), // Round up to nearest 100k
    ];

    for (final amount in convenientAmounts) {
      if (amount > totalAmount) {
        options.add(amount);
      }
    }

    // Convert to list, sort, and limit to 4 options
    final sortedOptions = options.filter((e) => e != totalAmount).toList()..sort();
    return sortedOptions.take(4).toList();
  }

  /// Check if exact amount can be made with available denominations
  static bool canMakeExactAmount(int amount, List<int> denominations) {
    var remaining = amount;
    final sortedDenoms = List<int>.from(denominations)..sort((a, b) => b.compareTo(a));

    for (final denom in sortedDenoms) {
      if (remaining >= denom) {
        remaining = remaining % denom;
      }
    }

    return remaining == 0;
  }
}

import 'dart:async';

enum BehaviorType {
  trailingEdge,
  leadingEdge,
  leadingAndTrailing,
}

class Debouncer {
  Timer? _debounceTimer;

  void debounce({
    required void Function() onDebounce,
    Duration duration = const Duration(milliseconds: 100),
    BehaviorType type = BehaviorType.trailingEdge,
  }) {
    if (type == BehaviorType.leadingEdge || type == BehaviorType.leadingAndTrailing) {
      onDebounce();
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      if (type == BehaviorType.trailingEdge || type == BehaviorType.leadingAndTrailing) {
        onDebounce();
      }
    });
  }

  void cancel() {
    _debounceTimer?.cancel();
  }
}

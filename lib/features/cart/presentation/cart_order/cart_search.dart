import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import 'cart_order_controller.dart';

class CartSearch extends ConsumerStatefulWidget {
  const CartSearch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartSearchState();
}

class _CartSearchState extends ConsumerState<CartSearch> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(cartOrderControllerProvider.select((s) => s.search));

    void onChanged(String value) {
      ref.read(cartOrderControllerProvider.notifier).setSearch(value);
    }

    void onClear() {
      _controller.clear();
      ref.read(cartOrderControllerProvider.notifier).clearSearch();
    }

    return Expanded(
      child: TextField(
        controller: _controller,
        autocorrect: false,
        enableSuggestions: false,
        style: const TextStyle(fontSize: 14),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Cari Produk...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: search.isNotEmpty
              ? InkWell(
                  onTap: onClear,
                  child: const Icon(Icons.highlight_off, color: AppTheme.accentRed),
                )
              : null,
          constraints: const BoxConstraints(minHeight: 48),
        ),
      ),
    );
  }
}

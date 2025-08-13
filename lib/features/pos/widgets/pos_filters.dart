import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/pos_provider.dart';

class PosFilters extends ConsumerStatefulWidget {
  const PosFilters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PosFiltersState();
}

class _PosFiltersState extends ConsumerState<PosFilters> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()
      ..addListener(() {
        ref.read(posFilterProvider.notifier).setSearch(controller.text);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(posFilterProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        spacing: 8,
        children: [
          for (final tab in PosTabItem.values) ...[
            FilterChip(
              label: Text(tab.label),
              onSelected: (_) => {
                ref.read(posFilterProvider.notifier).setTab(tab),
              },
              showCheckmark: false,
              selected: tab == filter.tab,
            ),
          ],
          const Spacer(),
          Expanded(
            child: TextField(
              autocorrect: false,
              enableSuggestions: false,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Cari Order...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filter.search.isNotEmpty
                    ? InkWell(
                        onTap: controller.clear,
                        child: const Icon(Icons.highlight_off),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

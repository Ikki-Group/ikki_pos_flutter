import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../utils/extensions.dart';
import 'pos_home_notifier.dart';
import 'pos_sales.dart';
import 'pos_sales_details.dart';

class PosHomePage extends ConsumerStatefulWidget {
  const PosHomePage({super.key});

  @override
  ConsumerState<PosHomePage> createState() => _PosHomePageState();
}

class _PosHomePageState extends ConsumerState<PosHomePage> {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppTheme.backgroundSecondary,
      child: Column(
        children: <Widget>[
          PosFilters(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: PosSales(),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 8,
                    child: PosSalesDetails(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
        children: <Widget>[
          for (final tab in PosTabItem.values) ...<Widget>[
            FilterChip(
              label: Text(tab.label),
              onSelected: (_) {
                ref.read(posFilterProvider.notifier).setTab(tab);
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
              onTapOutside: (_) => context.unfocus(),
              decoration: InputDecoration(
                hintText: 'Cari pesanan, nomor, nama...',
                contentPadding: EdgeInsets.zero,
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

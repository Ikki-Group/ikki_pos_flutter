import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/pos_theme.dart';
import '../provider/pos_provider.dart';
import '../widgets/pos_order_list_section.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  final searchController = TextEditingController();
  PosTabItem selectedTab = PosTabItem.process;
  String selectedId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ColoredBox(
        color: const Color.fromARGB(255, 248, 248, 248),
        child: DefaultTabController(
          length: PosTabItem.values.length,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TabBar(
                        onTap: (value) => setState(() => selectedTab = PosTabItem.values[value]),
                        tabs: [
                          for (final item in PosTabItem.values)
                            Tab(child: Text(item.label, style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        autocorrect: false,
                        enableSuggestions: false,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Cari Nama, No. Meja, No. Telp...',
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: POSTheme.borderDark),
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () => setState(searchController.clear),
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: PosOrderListSection(
                              search: searchController.text,
                              selectedId: selectedId,
                              selectedTab: selectedTab,
                              onSelected: (value) => setState(() => selectedId = value),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(selectedId),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

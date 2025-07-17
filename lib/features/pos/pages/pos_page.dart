import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PosPage extends ConsumerStatefulWidget {
  const PosPage({super.key});

  @override
  ConsumerState<PosPage> createState() => _PosPageState();
}

class _PosPageState extends ConsumerState<PosPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ColoredBox(
        color: Colors.white38,
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
                        tabs: [
                          for (final item in PosTabItem.values) Tab(text: item.label),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        autocorrect: false,
                        enableSuggestions: false,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        decoration: InputDecoration(
                          hintText: 'Cari Nama, No. Meja, No. Telp...',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: Text('data')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum PosTabItem {
  process(label: 'Process'),
  done(label: 'Done'),
  canceled(label: 'Void');

  const PosTabItem({required this.label});

  final String label;
}

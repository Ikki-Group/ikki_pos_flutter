import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pos_theme.dart';
import 'settings_printer_page.dart';

class SettingIndexPage extends ConsumerStatefulWidget {
  const SettingIndexPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingIndexPageState();
}

class _SettingIndexPageState extends ConsumerState<SettingIndexPage> {
  SettingIndexPageTab selectedTab = SettingIndexPageTab.printer;

  void _onTabChanged(SettingIndexPageTab tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color.fromARGB(255, 242, 242, 242),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text('Menu Pengaturan'),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final tab in SettingIndexPageTab.values) _buildTab(tab),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: switch (selectedTab) {
                    SettingIndexPageTab.printer => const SettingsPrinterPage(),
                    _ => const Placeholder(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(SettingIndexPageTab tab) {
    final isSelected = tab == selectedTab;

    return TextButton(
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        backgroundColor: WidgetStateColor.fromMap({
          WidgetState.any: isSelected ? POSTheme.primaryBlueLight.withValues(alpha: .3) : Colors.transparent,
        }),
        foregroundColor: WidgetStateColor.fromMap({
          WidgetState.any: isSelected ? POSTheme.primaryBlueDark : POSTheme.neutral500,
        }),
      ),
      onPressed: () => _onTabChanged(tab),
      child: Text(
        tab.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

enum SettingIndexPageTab {
  printer(label: 'Printer'),
  logs(label: 'Catatan Aktivitas');

  const SettingIndexPageTab({required this.label});

  final String label;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../device/device_page.dart';
import '../printer/printer_page.dart';
import 'settings_config.dart';

class SettingsLayout extends ConsumerStatefulWidget {
  const SettingsLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends ConsumerState<SettingsLayout> {
  SettingsTab selectedTab = SettingsTab.printer;

  void onTabChanged(SettingsTab tab) {
    selectedTab = tab;
    setState(() {});
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
              child: SettingSidebar(selectedTab: selectedTab, onTabChanged: onTabChanged),
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
                    SettingsTab.printer => const PrinterPage(),
                    SettingsTab.devices => const DevicePage(),
                    // SettingsTab.logs => const SettingDevPage(),
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
}

class SettingSidebar extends StatelessWidget {
  const SettingSidebar({required this.selectedTab, required this.onTabChanged, super.key});

  final SettingsTab selectedTab;
  final void Function(SettingsTab) onTabChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Text('Menu Pengaturan', style: textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (final tab in SettingsTab.values)
                    _TabItem(
                      tab: tab,
                      isSelected: tab == selectedTab,
                      onTap: () => onTabChanged(tab),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.tab, required this.isSelected, required this.onTap});

  final SettingsTab tab;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppTheme.primaryBlueLight.withValues(alpha: .3) : Colors.transparent;
    final fg = isSelected ? AppTheme.primaryBlueDark : AppTheme.borderDark;

    return TextButton(
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        backgroundColor: bg,
        foregroundColor: fg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onPressed: onTap,
      child: Text(
        tab.label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

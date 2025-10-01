import 'package:flutter/material.dart';

import '../../../core/config/pos_theme.dart';
import '../utils/setting_tab.dart';

class SettingSidebar extends StatelessWidget {
  const SettingSidebar({required this.selectedTab, required this.onTabChanged, super.key});

  final SettingTab selectedTab;
  final void Function(SettingTab) onTabChanged;

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
                  for (final tab in SettingTab.values)
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

  final SettingTab tab;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? POSTheme.primaryBlueLight.withValues(alpha: .3) : Colors.transparent;
    final fg = isSelected ? POSTheme.primaryBlueDark : POSTheme.borderDark;

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

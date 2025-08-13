import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/setting_tab.dart';
import '../widgets/setting_sidebar.dart';
import 'setting_dev_page.dart';
import 'settings_printer_page.dart';

class SettingIndexPage extends ConsumerStatefulWidget {
  const SettingIndexPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingIndexPageState();
}

class _SettingIndexPageState extends ConsumerState<SettingIndexPage> {
  SettingTab selectedTab = SettingTab.printer;

  void onTabChanged(SettingTab tab) {
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
                    SettingTab.printer => const SettingsPrinterPage(),
                    SettingTab.logs => const SettingDevPage(),
                    SettingTab.dev => const SettingDevPage(),
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

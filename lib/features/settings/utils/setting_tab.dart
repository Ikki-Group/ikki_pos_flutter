enum SettingTab {
  printer(label: 'Printer'),
  logs(label: 'Catatan Aktivitas'),
  devices(label: 'Perangkat')
  // dev(label: 'Pengembang')
  ;

  const SettingTab({required this.label});

  final String label;
}

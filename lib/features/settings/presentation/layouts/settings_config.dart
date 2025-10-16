enum SettingsTab {
  printer(label: 'Printer'),
  logs(label: 'Catatan Aktivitas'),
  devices(label: 'Perangkat')
  // dev(label: 'Pengembang')
  ;

  const SettingsTab({required this.label});

  final String label;
}

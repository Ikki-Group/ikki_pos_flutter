enum HomeTabItem {
  selfOrder(label: "Self Order"),
  process(label: "Process"),
  done(label: "Done"),
  canceled(label: "Void");

  const HomeTabItem({required this.label});

  final String label;
}

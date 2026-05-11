class DhikrItem {
  final String text;
  final int count;
  final String ref;

  const DhikrItem({
    required this.text,
    required this.count,
    required this.ref,
  });
}

class DhikrCategory {
  final String category;
  final String icon;
  final String group;
  final List<DhikrItem> items;

  const DhikrCategory({
    required this.category,
    required this.icon,
    required this.group,
    required this.items,
  });
}
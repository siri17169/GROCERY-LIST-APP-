class GroceryItem {
  String name, qty, unit, category, emoji;
  bool isChecked;

  GroceryItem({
    required this.name,
    required this.qty,
    required this.unit,
    required this.category,
    required this.emoji,
    this.isChecked = false,
  });
}

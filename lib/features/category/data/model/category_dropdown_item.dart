class CategoryDropdownItem {
  final String id;
  final String name;

  CategoryDropdownItem({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryDropdownItem &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
enum CategoryType { length, weight, temperature }

class Unit {
  final String name;
  final String symbol;
  final CategoryType category;

  const Unit({
    required this.name,
    required this.symbol,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Unit &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          symbol == other.symbol &&
          category == other.category;

  @override
  int get hashCode => name.hashCode ^ symbol.hashCode ^ category.hashCode;
}

class UnitData {
  static const List<Unit> lengthUnits = [
    Unit(name: 'Meter', symbol: 'm', category: CategoryType.length),
    Unit(name: 'Kilometer', symbol: 'km', category: CategoryType.length),
    Unit(name: 'Centimeter', symbol: 'cm', category: CategoryType.length),
    Unit(name: 'Millimeter', symbol: 'mm', category: CategoryType.length),
  ];

  static const List<Unit> weightUnits = [
    Unit(name: 'Gram', symbol: 'g', category: CategoryType.weight),
    Unit(name: 'Kilogram', symbol: 'kg', category: CategoryType.weight),
    Unit(name: 'Milligram', symbol: 'mg', category: CategoryType.weight),
  ];

  static const List<Unit> tempUnits = [
    Unit(name: 'Celsius', symbol: '°C', category: CategoryType.temperature),
    Unit(name: 'Fahrenheit', symbol: '°F', category: CategoryType.temperature),
    Unit(name: 'Kelvin', symbol: 'K', category: CategoryType.temperature),
  ];

  static List<Unit> getUnitsForCategory(CategoryType category) {
    switch (category) {
      case CategoryType.length:
        return lengthUnits;
      case CategoryType.weight:
        return weightUnits;
      case CategoryType.temperature:
        return tempUnits;
    }
  }
}

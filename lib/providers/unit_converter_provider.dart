import 'package:flutter/foundation.dart';
import '../models/unit_model.dart';

class UnitConverterProvider extends ChangeNotifier {
  CategoryType _selectedCategory = CategoryType.length;
  String _inputValue = '25';
  late Unit _fromUnit;
  late Unit _toUnit;

  UnitConverterProvider() {
    _initCategoryDefaults();
  }

  CategoryType get selectedCategory => _selectedCategory;
  String get inputValue => _inputValue;
  Unit get fromUnit => _fromUnit;
  Unit get toUnit => _toUnit;

  List<Unit> get currentUnits => UnitData.getUnitsForCategory(_selectedCategory);

  void setCategory(CategoryType category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _initCategoryDefaults();
    notifyListeners();
  }

  void setInputValue(String value) {
    _inputValue = value;
    notifyListeners();
  }

  void setFromUnit(Unit unit) {
    _fromUnit = unit;
    notifyListeners();
  }

  void setToUnit(Unit unit) {
    _toUnit = unit;
    notifyListeners();
  }

  void swapUnits() {
    final temp = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = temp;
    notifyListeners();
  }

  void _initCategoryDefaults() {
    final units = currentUnits;
    if (units.isNotEmpty) {
      _fromUnit = units[0]; // e.g. Meter / Gram / Celsius
      _toUnit = units.length > 1 ? units[1] : units[0]; // e.g. Kilometer / Kilogram / Fahrenheit
    }
  }

  double? get calculatedValue {
    if (_inputValue.trim().isEmpty) return null;
    final value = double.tryParse(_inputValue.trim());
    if (value == null) return null;

    return convert(value, _fromUnit, _toUnit);
  }

  String get formattedResult {
    final result = calculatedValue;
    if (result == null) return '0';
    return formatNumber(result);
  }

  String formatNumber(double number) {
    if (number.isNaN || number.isInfinite) return '0';
    if (number == number.roundToDouble() && number.abs() < 1e12) {
      return number.toInt().toString();
    }
    String str = number.toStringAsFixed(6);
    while (str.contains('.') && (str.endsWith('0') || str.endsWith('.'))) {
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
        break;
      }
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

  double convert(double value, Unit from, Unit to) {
    if (from == to) return value;

    if (from.category == CategoryType.length) {
      final valueInMeters = _toBaseLength(value, from.name);
      return _fromBaseLength(valueInMeters, to.name);
    } else if (from.category == CategoryType.weight) {
      final valueInGrams = _toBaseWeight(value, from.name);
      return _fromBaseWeight(valueInGrams, to.name);
    } else if (from.category == CategoryType.temperature) {
      final valueInCelsius = _toCelsius(value, from.name);
      return _fromCelsius(valueInCelsius, to.name);
    }

    return value;
  }

  // Length conversion helpers (Base: Meter)
  double _toBaseLength(double val, String unitName) {
    switch (unitName) {
      case 'Kilometer':
        return val * 1000;
      case 'Centimeter':
        return val / 100;
      case 'Millimeter':
        return val / 1000;
      case 'Meter':
      default:
        return val;
    }
  }

  double _fromBaseLength(double baseMeters, String unitName) {
    switch (unitName) {
      case 'Kilometer':
        return baseMeters / 1000;
      case 'Centimeter':
        return baseMeters * 100;
      case 'Millimeter':
        return baseMeters * 1000;
      case 'Meter':
      default:
        return baseMeters;
    }
  }

  // Weight conversion helpers (Base: Gram)
  double _toBaseWeight(double val, String unitName) {
    switch (unitName) {
      case 'Kilogram':
        return val * 1000;
      case 'Milligram':
        return val / 1000;
      case 'Gram':
      default:
        return val;
    }
  }

  double _fromBaseWeight(double baseGrams, String unitName) {
    switch (unitName) {
      case 'Kilogram':
        return baseGrams / 1000;
      case 'Milligram':
        return baseGrams * 1000;
      case 'Gram':
      default:
        return baseGrams;
    }
  }

  // Temperature conversion helpers (Base: Celsius)
  double _toCelsius(double val, String unitName) {
    switch (unitName) {
      case 'Fahrenheit':
        return (val - 32) * 5 / 9;
      case 'Kelvin':
        return val - 273.15;
      case 'Celsius':
      default:
        return val;
    }
  }

  double _fromCelsius(double celsius, String unitName) {
    switch (unitName) {
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      case 'Celsius':
      default:
        return celsius;
    }
  }
}

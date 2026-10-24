import 'package:flutter/material.dart';
import '../models/unit_model.dart';

class UnitDropdown extends StatelessWidget {
  final String label;
  final Unit selectedUnit;
  final List<Unit> units;
  final ValueChanged<Unit?> onChanged;

  const UnitDropdown({
    super.key,
    required this.label,
    required this.selectedUnit,
    required this.units,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Unit>(
              value: units.contains(selectedUnit) ? selectedUnit : units.first,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade700,
              ),
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              items: units.map((Unit unit) {
                return DropdownMenuItem<Unit>(
                  value: unit,
                  child: Text(unit.name),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

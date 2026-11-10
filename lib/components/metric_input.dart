import 'package:flutter/material.dart';

class MetricInputRow extends StatelessWidget {
  final String label;
  final String hint;
  final String selectedUnit;
  final List<String> units;
  final ValueChanged<String> onUnitChanged;
  final TextEditingController controller;

  const MetricInputRow({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),

          const Spacer(),

          SizedBox(
            width: 70,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Row(
            children: units.map((unit) {
              final isSelected = unit == selectedUnit;

              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: GestureDetector(
                  onTap: () => onUnitChanged(unit),
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF3F7E9)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF7A8D5A)
                            : Colors.transparent,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unit,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? const Color(0xFF5A6B3F)
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HealthDateTimeField extends StatefulWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const HealthDateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  factory HealthDateTimeField.date({
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return HealthDateTimeField(
      label: "Date",
      value: DateFormat('MMM d, yyyy').format(date),
      onTap: onTap,
    );
  }

  factory HealthDateTimeField.time({
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    final now = DateTime.now();

    return HealthDateTimeField(
      label: "Time",
      value: DateFormat.jm().format(
        DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  State<HealthDateTimeField> createState() => _HealthDateTimeFieldState();
}

class _HealthDateTimeFieldState extends State<HealthDateTimeField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: SizedBox(
        height: 45,
        child: Row(
          children: [

            Text(
              widget.label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),

            const Spacer(),

            Text(
              widget.value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.chevron_right,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
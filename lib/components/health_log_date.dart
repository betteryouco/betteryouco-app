import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget HealthDateField(String label, DateTime value, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      height: 45,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),

          const Spacer(),

          Text(
            DateFormat('MMM d, yyyy').format(value),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),

          const SizedBox(width: 8),

          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    ),
  );
}

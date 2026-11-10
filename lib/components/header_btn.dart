import 'package:flutter/material.dart';

Widget unitButton(String text, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 8,
    ),
    decoration: BoxDecoration(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: selected
            ? Colors.black
            : Colors.grey,
      ),
    ),
  );
}
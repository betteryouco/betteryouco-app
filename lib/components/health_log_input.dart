import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget HealthInputField(String label,
    String hint,
    TextEditingController controller,
    String? errorText, {
    bool allowDecimal = false,
  }) {
  return SizedBox(
    height: 45,
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),

        const Spacer(),

        Container(
          width: 220.w,
          child: TextFormField(
            controller: controller,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
            inputFormatters: [
              if (allowDecimal)
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
              else
                FilteringTextInputFormatter.digitsOnly,
            ],

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),

            decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w100,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                isCollapsed: true,

                errorStyle: TextStyle(color: Colors.red),
                errorText: errorText
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter $label";
              }

              final number = allowDecimal ? double.tryParse(value) : int.tryParse(value);

              if (number == null) {
                return "Invalid number";
              }

              if (number <= 0) {
                return "$label must be greater than 0";
              }

              return null;
            },
          ),
        ),
      ],
    ),
  );
}

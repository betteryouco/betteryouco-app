import 'package:flutter/material.dart';

class HealthLogSheet extends StatefulWidget {
  final Widget child;

  const HealthLogSheet({
    super.key,
    required this.child,
  });

  @override
  State<HealthLogSheet> createState() => _HealthLogSheetState();
}

class _HealthLogSheetState extends State<HealthLogSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF7F7F5),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: SingleChildScrollView(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
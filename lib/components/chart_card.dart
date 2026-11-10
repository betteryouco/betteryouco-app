import 'package:flutter/material.dart';
import 'chart_header.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onViewAll;
  final EdgeInsetsGeometry padding;

  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.onViewAll,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartHeader(
            title: title,
            onViewAll: onViewAll,
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}
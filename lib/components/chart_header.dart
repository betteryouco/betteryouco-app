import 'package:flutter/material.dart';

class ChartHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final String actionText;

  const ChartHeader({
    super.key,
    required this.title,
    this.onViewAll,
    this.actionText = 'View all',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

/*        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onViewAll,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 6,
            ),
            child: Row(
              children: [
                Text(
                  actionText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  size: 18,
                ),
              ],
            ),
          ),
        ),*/
      ],
    );
  }
}
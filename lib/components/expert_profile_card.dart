import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpertProfileCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isOnline;
  final VoidCallback? onTap;

  const ExpertProfileCard({
    Key? key,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.isOnline = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.headingText,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        specialization,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.bodyText,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color(0xffF4B400),
                            ),
                            itemCount: 5,
                            itemSize: 18,
                            unratedColor: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$rating (${_formatReviews(reviewCount)})',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatReviews(int count) {
    return count.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
    );
  }
}
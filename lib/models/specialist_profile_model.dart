import 'dart:convert';

class SpecialistProfileModel {
  final String? bio;

  final String? photoUrl;

  final String? introVideoUrl;

  final List<String> languages;

  final List<String> specialties;

  final double? pricing;

  final String verificationStatus;

  final String? tier;

  final double rating;

  const SpecialistProfileModel({
    this.bio,
    this.photoUrl,
    this.introVideoUrl,
    required this.languages,
    required this.specialties,
    this.pricing,
    required this.verificationStatus,
    this.tier,
    required this.rating,
  });

  factory SpecialistProfileModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    return SpecialistProfileModel(
      bio: data['bio'],

      photoUrl: data['photo_url'],

      introVideoUrl: data['intro_video_url'],

      // languages: List<String>.from(
      //   data['languages'] ?? [],
      // ),
      //
      // specialties: List<String>.from(
      //   data['specialties'] ?? [],
      // ),

      languages: data['languages'] is String
          ? List<String>.from(jsonDecode(data['languages']))
          : List<String>.from(data['languages'] ?? []),

      specialties: data['specialties'] is String
          ? List<String>.from(jsonDecode(data['specialties']))
          : List<String>.from(data['specialties'] ?? []),

      pricing: data['pricing'] == null
          ? null
          : data['pricing'] is String
          ? double.parse(data['pricing'])
          : (data['pricing'] as num).toDouble(),

      verificationStatus:
      data['verification_status'] ?? 'pending',

      tier: data['tier'],

      rating: data['rating'] == null
          ? 0
          : (data['rating'] as num).toDouble(),
    );
  }
}
class ProgramModuleModel {
  final int? week;
  final String title;
  final String? description;

  const ProgramModuleModel({
    this.week,
    required this.title,
    this.description,
  });

  factory ProgramModuleModel.fromJson(Map<String, dynamic> json) {
    return ProgramModuleModel(
      week: json['week'] is int
          ? json['week']
          : int.tryParse('${json['week']}'),
      title: json['title'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'title': title,
      if (description != null && description!.isNotEmpty)
        'description': description,
    };
  }
}

class ProgramSpecialistSummary {
  final int id;
  final String name;
  final String? photo;
  final double? rating;
  final String? tier;

  const ProgramSpecialistSummary({
    required this.id,
    required this.name,
    this.photo,
    this.rating,
    this.tier,
  });

  factory ProgramSpecialistSummary.fromJson(Map<String, dynamic> json) {
    return ProgramSpecialistSummary(
      id: json['id'],
      name: json['name'] ?? '',
      photo: json['photo'],
      rating: json['rating'] != null
          ? double.tryParse('${json['rating']}')
          : null,
      tier: json['tier'],
    );
  }
}

class ProgramModel {
  final int id;
  final int? specialistId;
  final String title;
  final String? description;
  final String? tagline;
  final List<String> highlights;
  final List<String> tags;
  final int? durationWeeks;
  final int? durationWeeksMax;
  final double? price;
  final String? currency;
  final int? revenueShareExpertPercent;
  final List<ProgramModuleModel> contentModules;
  final DateTime? createdAt;
  final ProgramSpecialistSummary? specialist;

  const ProgramModel({
    required this.id,
    this.specialistId,
    required this.title,
    this.description,
    this.tagline,
    this.highlights = const [],
    this.tags = const [],
    this.durationWeeks,
    this.durationWeeksMax,
    this.price,
    this.currency,
    this.revenueShareExpertPercent,
    this.contentModules = const [],
    this.createdAt,
    this.specialist,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    final modules = (json['content_modules'] as List?) ?? [];
    final highlights = (json['highlights'] as List?) ?? [];
    final tags = (json['tags'] as List?) ?? [];

    final specialist = json['specialist'] != null
        ? ProgramSpecialistSummary.fromJson(json['specialist'])
        : null;

    return ProgramModel(
      id: json['id'],
      specialistId: json['specialist_id'] ?? specialist?.id,
      title: json['title'] ?? '',
      description: json['description'],
      tagline: json['tagline'],
      highlights: highlights.map((e) => '$e').toList(),
      tags: tags.map((e) => '$e').toList(),
      durationWeeks: json['duration_weeks'],
      durationWeeksMax: json['duration_weeks_max'],
      price: json['price'] != null
          ? double.tryParse('${json['price']}')
          : null,
      currency: json['currency'],
      revenueShareExpertPercent: json['revenue_share_expert_percent'],
      contentModules: modules
          .map((e) => ProgramModuleModel.fromJson(e))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      specialist: specialist,
    );
  }
}

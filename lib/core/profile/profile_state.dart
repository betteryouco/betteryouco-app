import 'package:betteryou_co/models/profile_model.dart';

import '../../../models/health_summary_model.dart';
import '../../models/specialist_profile_model.dart';

class ProfileState {
  final bool isLoading;

  final bool isSuccess;

  final String? successMessage;

  final String? errorMessage;

  final Map<String, dynamic>? validationErrors;
  final ProfileModel? summary;
  final SpecialistProfileModel? specialistProfile;

  const ProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.successMessage,
    this.errorMessage,
    this.validationErrors,
    this.summary,
    this.specialistProfile,
  });

  factory ProfileState.initial() {
    return const ProfileState();
  }

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? successMessage,
    String? errorMessage,
    Map<String, dynamic>? validationErrors,
    ProfileModel? summary,
    SpecialistProfileModel? specialistProfile,

  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage,
      errorMessage: errorMessage,
      validationErrors: validationErrors,
      summary: summary ?? this.summary,
      specialistProfile: specialistProfile ?? this.specialistProfile,

    );
  }
}

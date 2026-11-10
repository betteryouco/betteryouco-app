import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class CompleteSpecialistProfileRequest {
  final String? bio;

  final XFile? photo;

  final XFile? introVideo;

  final List<String>? languages;

  final List<String>? specialties;

  final double? pricing;

  const CompleteSpecialistProfileRequest({
    this.bio,
    this.photo,
    this.introVideo,
    this.languages,
    this.specialties,
    this.pricing,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    //---------------------------------------------------
    // Text
    //---------------------------------------------------

    if (bio != null) {
      formData.fields.add(MapEntry('bio', bio!));
    }

    if (pricing != null) {
      formData.fields.add(MapEntry('pricing', pricing.toString()));
    }

    //---------------------------------------------------
    // Languages
    //---------------------------------------------------

    if (languages != null) {
      for (final language in languages!) {
        formData.fields.add(MapEntry('languages[]', language));
      }
    }

    //---------------------------------------------------
    // Specialties
    //---------------------------------------------------

    if (specialties != null) {
      for (final specialty in specialties!) {
        formData.fields.add(MapEntry('specialties[]', specialty));
      }
    }

    //---------------------------------------------------
    // Profile Photo
    //---------------------------------------------------

    if (photo != null) {
      formData.files.add(
        MapEntry(
          'photo',
          await MultipartFile.fromFile(photo!.path, filename: photo!.name),
        ),
      );
    }

    //---------------------------------------------------
    // Intro Video
    //---------------------------------------------------

    if (introVideo != null) {
      formData.files.add(
        MapEntry(
          'intro_video',
          await MultipartFile.fromFile(
            introVideo!.path,
            filename: introVideo!.name,
          ),
        ),
      );
    }

    return formData;
  }
}

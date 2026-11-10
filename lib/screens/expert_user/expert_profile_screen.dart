import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_1.dart';
import 'dart:io';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../core/profile/ProfileeController.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/specialist_profile_request.dart';

class ExpertProfileScreen extends StatefulWidget {
  const ExpertProfileScreen({super.key});

  @override
  State<ExpertProfileScreen> createState() => ExpertProfileScreenState();
}

class ExpertProfileScreenState extends State<ExpertProfileScreen> {
  final _bioController = TextEditingController();
  final _pricingController = TextEditingController();

  XFile? _photo;
  XFile? _video;

  String? _photoUrl;
  String? _introVideoUrl;

  final List<String> _selectedLanguages = [];
  final List<String> _selectedSpecialties = [];

  final List<String> languages = ["English", "Urdu", "Punjabi", "Arabic"];

  final List<String> specialties = [
    "Stress",
    "Nutrition",
    "Fitness",
    "Sleep",
    "Mindfulness",
    "Weight Loss",
  ];

  final ImagePicker picker = ImagePicker();

  //---------------------------------------------------
  // Pick Image
  //---------------------------------------------------

  Future<void> _pickPhoto() async {
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file == null) return;

    setState(() {
      _photo = file;
    });
  }

  //---------------------------------------------------
  // Pick Video
  //---------------------------------------------------

  Future<void> _pickVideo() async {
    final file = await picker.pickVideo(source: ImageSource.gallery);

    if (file == null) return;

    setState(() {
      _video = file;
    });
  }

  //---------------------------------------------------
  // Save
  //---------------------------------------------------

  Future<void> _save() async {
    final controller = context.read<ProfileeController>();

    final request = CompleteSpecialistProfileRequest(
      bio: _bioController.text.trim(),

      pricing: double.tryParse(_pricingController.text),

      photo: _photo,

      introVideo: _video,

      languages: _selectedLanguages,

      specialties: _selectedSpecialties,
    );

    final success = await controller.completeSpecialistProfile(request);

    if (!mounted) return;

    if (success) {
      setState(() {
        // Clear text fields
        _bioController.clear();
        _pricingController.clear();

        // Reset picked media files (assuming XFile or File type)
        _photo = null;
        _video = null;

        // Clear selected chips
        _selectedLanguages.clear();
        _selectedSpecialties.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.successMessage ?? "Profile Updated")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileeController>(
      builder: (context, profileController, child) {
        return BlurryModalProgressHUD(
          inAsyncCall: profileController.state.isLoading,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.primaryBtn,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //---------------------------------------------------
                // Bio
                //---------------------------------------------------
                TextFormField(
                  controller: _bioController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    hintText: "Tell clients about yourself",
                  ),
                ),

                const SizedBox(height: 20),

                //---------------------------------------------------
                // Photo
                //---------------------------------------------------
                OutlinedButton.icon(
                  onPressed: _pickPhoto,

                  icon: const Icon(Icons.image),

                  label: Text(
                    _photo == null ? "Choose Profile Photo" : "Change Photo",
                  ),
                ),

                if (_photo != null) ...[
                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: Image.file(File(_photo!.path), height: 140),
                  ),
                ] else if (_photoUrl != null && _photoUrl!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_photoUrl!, height: 140),
                  ),
                ],

                const SizedBox(height: 24),

                //---------------------------------------------------
                // Video
                //---------------------------------------------------
                OutlinedButton.icon(
                  onPressed: _pickVideo,

                  icon: const Icon(Icons.video_call),

                  label: Text(
                    _video == null ? "Choose Intro Video" : "Change Video",
                  ),
                ),

                if (_video != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_video!.name),
                  ),

                const SizedBox(height: 24),

                //---------------------------------------------------
                // Languages
                //---------------------------------------------------
                const Text("Languages"),

                Wrap(
                  spacing: 8,

                  children: languages.map((e) {
                    final selected = _selectedLanguages.contains(e);

                    return FilterChip(
                      label: Text(e),

                      selected: selected,

                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedLanguages.add(e);
                          } else {
                            _selectedLanguages.remove(e);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                //---------------------------------------------------
                // Specialties
                //---------------------------------------------------
                const Text("Specialties"),

                Wrap(
                  spacing: 8,

                  children: specialties.map((e) {
                    final selected = _selectedSpecialties.contains(e);

                    return FilterChip(
                      label: Text(e),

                      selected: selected,

                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedSpecialties.add(e);
                          } else {
                            _selectedSpecialties.remove(e);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                //---------------------------------------------------
                // Pricing
                //---------------------------------------------------
                TextFormField(
                  controller: _pricingController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    labelText: "Consultation Fee",
                  ),
                ),

                const SizedBox(height: 40),

                //---------------------------------------------------
                // Save
                //---------------------------------------------------
                Button1("Save", _save),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadUser() async {
    final session = SessionManager.instance;
    final user = await session.getUser();

    setState(() {
      // userName = user?['name'] ?? '';
    });
  }

  void populateData() {
    final profile = context.read<ProfileeController>().state.specialistProfile;

    if (profile == null) return;

    _bioController.text = profile.bio ?? "";

    _pricingController.text = profile.pricing?.toString() ?? "";

    _selectedLanguages
      ..clear()
      ..addAll(profile.languages);

    _selectedSpecialties
      ..clear()
      ..addAll(profile.specialties);

    _photoUrl = profile.photoUrl;

    _introVideoUrl = profile.introVideoUrl;

    setState(() {});
  }
}

import 'package:flutter/material.dart';

enum Gender { male, female, nonBinary, preferNotToSay }
enum DailyActivity { sedentary, lightlyActive, moderatelyActive, veryActive }
enum HeightUnit { cm, ft }
enum WeightUnit { kg, lbs }

class ProfileController extends ChangeNotifier {
  /// Wizard Step
  int _currentStep = 0;
  int get currentStep => _currentStep;
  static const int totalSteps = 4;

  /// Personal Info
  int _age = 20;
  int get age => _age;
  Gender? _gender;
  Gender? get gender => _gender;

  /// Biometrics
  double _height = 175;
  double get height => _height;
  double _weight = 60;
  double get weight => _weight;
  HeightUnit _heightUnit = HeightUnit.cm;
  HeightUnit get heightUnit => _heightUnit;
  WeightUnit _weightUnit = WeightUnit.kg;
  WeightUnit get weightUnit => _weightUnit;

  DailyActivity? _dailyActivity;
  DailyActivity? get dailyActivity => _dailyActivity;
  //---------------------------------------
  /// Step Navigation
  //---------------------------------------

  bool get isFirstStep => _currentStep == 0;

  bool get isLastStep => _currentStep == totalSteps - 1;

  double get progress => (_currentStep + 1) / totalSteps;

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void jumpToStep(int index) {
    if (index >= 0 && index < totalSteps) {
      _currentStep = index;
      notifyListeners();
    }
  }

  //---------------------------------------
  /// Age
  //---------------------------------------

  void updateAge(int value) {
    _age = value;
    debugPrint("Controller Age Updated to: $_age");
    notifyListeners();
  }

  //---------------------------------------
  /// Gender
  //---------------------------------------

  void updateGender(Gender value) {
    _gender = value;
    notifyListeners();
  }

  void updateDailyActivity(DailyActivity value) {
    _dailyActivity = value;
    notifyListeners();
  }

  //---------------------------------------
  /// Height
  //---------------------------------------

  void updateHeight(double value) {
    _height = value;
    notifyListeners();
  }

  void updateHeightUnit(HeightUnit unit) {
    _heightUnit = unit;
    notifyListeners();
  }

  //---------------------------------------
  /// Weight
  //---------------------------------------

  void updateWeight(double value) {
    _weight = value;
    notifyListeners();
  }

  void updateWeightUnit(WeightUnit unit) {
    _weightUnit = unit;
    notifyListeners();
  }

  //---------------------------------------
  /// Reset
  //---------------------------------------

  void reset() {
    _currentStep = 0;
    _age = 20;
    _gender = null;
    _dailyActivity = null;
    _height = 175;
    _weight = 60;
    _heightUnit = HeightUnit.cm;
    _weightUnit = WeightUnit.kg;

    notifyListeners();
  }

  String get heightText {
    if (_heightUnit == HeightUnit.cm) {
      return "${_height.round()} cm";
    }

    final totalInches = _height / 2.54;
    final feet = totalInches ~/ 12;
    final inches = (totalInches % 12).round();

    return "$feet'$inches\"";
  }

  String get weightText {
    if (_weightUnit == WeightUnit.kg) {
      return "${_weight.round()} kg";
    }

    final lbs = _weight * 2.20462;
    return "${lbs.round()} lbs";
  }


  // Change your Feet helper getters to return total INCHES
  double get rulerMinHeight => heightUnit == HeightUnit.cm ? 100 : 36; // 36 inches = 3 ft
  double get rulerMaxHeight => heightUnit == HeightUnit.cm ? 220 : 96; // 96 inches = 8 ft

  double get rulerCurrentHeight {
    if (heightUnit == HeightUnit.cm) return _height;
    return _height / 2.54; // Convert stored CM to Inches
  }

  void updateHeightFromRuler(double value) {
    if (heightUnit == HeightUnit.cm) {
      _height = value;
    } else {
      _height = value * 2.54; // Convert Inches back to CM for internal storage
    }
    notifyListeners();
  }
}

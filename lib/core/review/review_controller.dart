import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import 'review_service.dart';
import 'review_state.dart';

class ReviewController extends ChangeNotifier {
  final ReviewService _service;

  ReviewController(this._service);

  ReviewState _state = ReviewState.initial();

  ReviewState get state => _state;

  void _setState(ReviewState state) {
    _state = state;
    notifyListeners();
  }

  Future<void> loadReviews(int specialistId) async {
    _setState(_state.copyWith(isLoading: true, errorMessage: null));

    try {
      final reviews = await _service.loadReviews(specialistId);

      _setState(_state.copyWith(isLoading: false, reviews: reviews));
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoading: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<bool> submitReview({
    required int specialistId,
    required int rating,
    String? body,
  }) async {
    _setState(_state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final review = await _service.submitReview(
        specialistId: specialistId,
        rating: rating,
        body: body,
      );

      final updated = [
        review,
        ..._state.reviews.where((r) => r.id != review.id),
      ];

      _setState(_state.copyWith(isSubmitting: false, reviews: updated));

      return true;
    } on ApiException catch (e) {
      _setState(_state.copyWith(isSubmitting: false, errorMessage: e.message));

      return false;
    } catch (_) {
      _setState(
        _state.copyWith(
          isSubmitting: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );

      return false;
    }
  }
}

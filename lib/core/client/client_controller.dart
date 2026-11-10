import 'package:flutter/material.dart';

import '../../core/network/api_exception.dart';
import '../../models/client_detail_model.dart';
import '../../models/health_summary_model.dart';
import '../../models/stress_assessment_dashboard_response.dart';
import 'client_service.dart';
import 'client_state.dart';

class ClientController extends ChangeNotifier {
  final ClientService _service;

  ClientController(this._service);

  ClientState _state = ClientState.initial();

  ClientState get state => _state;

  void _setState(ClientState state) {
    _state = state;
    notifyListeners();
  }

  //---------------------------------------------------
  // Clients List
  //---------------------------------------------------

  Future<void> loadActiveClients() async {
    _setState(_state.copyWith(isLoadingList: true, errorMessage: null));

    try {
      final clients = await _service.loadClients("active");

      _setState(_state.copyWith(isLoadingList: false, activeClients: clients));
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoadingList: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingList: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> loadCompletedClients() async {
    _setState(_state.copyWith(isLoadingList: true, errorMessage: null));

    try {
      final clients = await _service.loadClients("completed");

      _setState(
        _state.copyWith(isLoadingList: false, completedClients: clients),
      );
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoadingList: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingList: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> loadAtRiskClients() async {
    _setState(_state.copyWith(isLoadingList: true, errorMessage: null));

    try {
      final clients = await _service.loadClients("at-risk");

      _setState(_state.copyWith(isLoadingList: false, atRiskClients: clients));
    } on ApiException catch (e) {
      _setState(_state.copyWith(isLoadingList: false, errorMessage: e.message));
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingList: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  //---------------------------------------------------
  // Client Detail (profile + assessments + vitals together)
  //---------------------------------------------------

  Future<void> loadClientProfile(int enrollmentId) async {
    _setState(
      _state.copyWith(
        isLoadingDetail: true,
        errorMessage: null,
        clientDetail: null,
        clientAssessments: null,
        clientVitals: null,
      ),
    );

    try {
      final detailFuture = _service.loadClientDetail(enrollmentId);
      final assessmentsFuture = _service.loadClientAssessments(enrollmentId);
      final vitalsFuture = _service.loadClientVitals(enrollmentId);

      final ClientDetailModel detail = await detailFuture;
      final AssessmentDashboardResponse assessments = await assessmentsFuture;
      final HealthSummaryModel vitals = await vitalsFuture;

      _setState(
        _state.copyWith(
          isLoadingDetail: false,
          clientDetail: detail,
          clientAssessments: assessments,
          clientVitals: vitals,
        ),
      );
    } on ApiException catch (e) {
      _setState(
        _state.copyWith(isLoadingDetail: false, errorMessage: e.message),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          isLoadingDetail: false,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}

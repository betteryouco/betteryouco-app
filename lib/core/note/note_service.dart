import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/note_model.dart';

class NoteService {
  final Dio _dio = ApiClient().dio;

  Future<List<NoteModel>> loadMyNotes() async {
    try {
      final response = await _dio.get("/client/notes");

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => NoteModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<NoteModel>> loadClientNotes(int enrollmentId) async {
    try {
      final response = await _dio.get(
        "/specialist/clients/$enrollmentId/notes",
      );

      final data = (response.data["data"] as List?) ?? [];

      return data.map((e) => NoteModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<NoteModel> addNote(int enrollmentId, String body) async {
    try {
      final response = await _dio.post(
        "/specialist/clients/$enrollmentId/notes",
        data: {"body": body},
      );

      return NoteModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response == null) {
      return ApiException(
        message: "Unable to connect to server.",
      );
    }

    final data = e.response?.data;

    if (e.response?.statusCode == 422) {
      return ApiException(
        message: data["message"] ?? "Validation failed.",
        statusCode: 422,
        errors: data["errors"],
      );
    }

    return ApiException(
      message: data["message"] ?? "Something went wrong.",
      statusCode: e.response?.statusCode,
    );
  }
}

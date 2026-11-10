import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../guest/guest_service.dart';

class GuestSessionManager {
  GuestSessionManager._();

  static final GuestSessionManager instance =
  GuestSessionManager._();

  final GuestService _guestService = GuestService();


  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  static const String _guestTokenKey =
      'guest_session_token';

  /// Returns the existing guest token, or creates a real one via the
  /// backend if none is cached. Never fabricates a token locally — a
  /// client-only UUID with no matching guest_sessions row on the server
  /// would fail as soon as it's actually submitted with anything.
  Future<String> getToken() async {
    final token = await _storage.read(
      key: _guestTokenKey,
    );

    if (token != null && token.isNotEmpty) {
      return token;
    }

    return refreshSession();
  }

  /// Clears whatever guest token is cached and creates a fresh,
  /// backend-issued one. Used both to start a session from scratch and to
  /// recover when the backend rejects a cached token as invalid — e.g.
  /// its guest_sessions row no longer exists (expired, or the app was
  /// reinstalled against a different backend environment).
  Future<String> refreshSession() async {
    await _storage.delete(key: _guestTokenKey);

    final response = await _guestService.createGuestSession();

    await _storage.write(
      key: _guestTokenKey,
      value: response.guestSessionToken,
    );

    return response.guestSessionToken;
  }

  /// Removes guest token.
  Future<void> clear() async {
    await _storage.delete(
      key: _guestTokenKey,
    );
  }

  /// Returns true if a guest token exists.
  Future<bool> hasGuestSession() async {
    return await _storage.containsKey(
      key: _guestTokenKey,
    );
  }


  /// Ensures a guest session exists (creating one via the backend if
  /// needed) — kept as a separate name from getToken() for call sites
  /// that only care about the side effect, not the returned value.
  Future<void> initialize() async {
    await getToken();
  }
}
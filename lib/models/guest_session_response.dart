class GuestSessionResponse {
  final String guestSessionToken;

  const GuestSessionResponse({
    required this.guestSessionToken,
  });

  factory GuestSessionResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'];

    return GuestSessionResponse(
      guestSessionToken: data['guest_session_token'],
    );
  }
}
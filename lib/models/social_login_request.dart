class SocialLoginRequest {
  final String provider;
  final String token;

  const SocialLoginRequest({
    required this.provider,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      "provider": provider,
      "token": token,
    };
  }
}
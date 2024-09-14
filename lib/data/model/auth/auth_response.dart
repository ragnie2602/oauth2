class AuthResponse {
  String? accessToken;
  String? refreshToken;

  AuthResponse({this.accessToken, this.refreshToken});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;

    return data;
  }
}

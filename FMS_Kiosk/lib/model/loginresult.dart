class LoginResult {
  int status;
  String accessToken;

  LoginResult({
    this.status,
    this.accessToken
});

  LoginResult.withParams(int status, String accessToken) {
    this.status = status;
    this.accessToken = accessToken;
  }

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      status: json['Status'],
      accessToken: json['Token'],
    );
  }
}
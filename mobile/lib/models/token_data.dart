class TokenData {
  final String authToken, refreshToken;

  TokenData(this.authToken, this.refreshToken);

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(json['authToken'], json['refreshToken']);
  }
}

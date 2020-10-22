class Token {
  String accessToken;
  String refreshToken;

  @override
  String toString() {
    // TODO: implement toString
    return '{ access: ${accessToken}, refresh: ${refreshToken} }';
  }
}
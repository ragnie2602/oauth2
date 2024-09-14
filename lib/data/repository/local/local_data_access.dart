abstract class LocalDataAccess {
  Future clearAccessToken();
  Future clearRefreshToken();

  Future<String> getAccessToken();
  Future<String> getIDToken();
  Future<String> getRefreshToken();

  Future setAccessToken(String accessToken);
  Future setIDToken(String idToken);
  Future setRefreshToken(String refreshToken);
}

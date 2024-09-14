import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_flutter/data/model/auth/auth_response.dart';
import 'package:my_flutter/data/model/wrapper.dart';
import 'package:my_flutter/data/repository/local/local_data_access.dart';
import 'package:my_flutter/di/di.dart';

class AuthRepository {
  final dio = getIt.get<Dio>();
  final googleSignIn = GoogleSignIn(scopes: ['email', 'openid']);
  final localDataAccess = getIt.get<LocalDataAccess>();

  String accessToken = '', refreshToken = '';
  final appauth = const FlutterAppAuth();
  final issuer = 'https://id-test.trueconnect.vn';

  Future<ResponseWrapper<AuthResponse>> googleLogin() async {
    try {
      final account = await googleSignIn.signIn();

      if (account != null) {
        final googleAuth = await googleSignIn.currentUser?.authentication;

        final authResponse = AuthResponse(accessToken: googleAuth?.accessToken);
        await localDataAccess.setAccessToken(googleAuth?.accessToken ?? '');
        await localDataAccess.setIDToken(googleAuth?.idToken ?? '');

        return ResponseWrapper.success(authResponse);
      } else {
        debugPrint('account is nullllllll');
        return ResponseWrapper.error(400, "Lỗi không xác định");
      }
    } catch (e) {
      debugPrint("exceptionnnnnnn, fuck!!@");
      debugPrint(e.toString());
      return ResponseWrapper.error(400, "Sai tài khoản mật khẩu");
    }
  }

  Future<ResponseWrapper<AuthResponse>> login(
      String username, String password) async {
    try {
      final response = await dio
          .post('https://work-api-dev.eztek.net/api/authenticate', data: {
        'username': username,
        'password': password,
        'rememberMe': true
      });

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await localDataAccess.setAccessToken(authResponse
            .accessToken!); // Set the accessToken to secured storage
        await localDataAccess.setRefreshToken(
            authResponse.refreshToken!); // Similar to the above

        return ResponseWrapper.success(authResponse);
      } else {
        return ResponseWrapper.error(400, "Lỗi không xác định");
      }
    } catch (e) {
      return ResponseWrapper.error(
          400, "Tên tài khoản hoặc mật khẩu không chính xác");
    }
  }

  Future logout() async {
    await localDataAccess.clearAccessToken();
    await localDataAccess.clearRefreshToken();
  }

  Future<ResponseWrapper<AuthResponse>> refreshLogin() async {
    accessToken = await localDataAccess.getAccessToken();
    refreshToken = await localDataAccess.getRefreshToken();

    try {
      final response = await dio.get(
          'https://work-api-dev.eztek.net/api/refresh-token',
          queryParameters: {
            'accessToken': accessToken,
            'refreshToken': refreshToken,
          });

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await localDataAccess.setAccessToken(authResponse.accessToken ?? '');
        await localDataAccess.setRefreshToken(authResponse.refreshToken ?? '');

        return ResponseWrapper.success(authResponse);
      } else {
        return ResponseWrapper.error(
            response.statusCode ?? 500, response.statusMessage ?? '');
      }
    } catch (e) {
      return ResponseWrapper.error(500, 'Lỗi không xác định');
    }
  }

  // All of parameters below (client_id, client_secret, ...) are used for debug.apk not release.apk
  Future<ResponseWrapper<AuthorizationTokenResponse>> trueConnectLogin() async {
    try {
      final AuthorizationTokenResponse? authorizationTokenResponse =
          await appauth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'localhost_identity', // clientId
          'com.eztek.trueconnect://login-callback', // redirectURL
          clientSecret: 'no_important',
          issuer: issuer,
          scopes: ["openid", "profile", "email", "roles", "offline_access"],
          serviceConfiguration: AuthorizationServiceConfiguration(
              authorizationEndpoint: '$issuer/connect/authorize',
              tokenEndpoint: '$issuer/connect/token',
              endSessionEndpoint: '$issuer/connect/endsession'),
        ),
      );

      localDataAccess
          .setAccessToken(authorizationTokenResponse?.accessToken ?? '');
      localDataAccess
          .setRefreshToken(authorizationTokenResponse?.refreshToken ?? '');
      localDataAccess.setIDToken(authorizationTokenResponse?.idToken ?? '');

      // Just print to console to identify we're successful
      debugPrint(
          'auth response idToken: ${authorizationTokenResponse?.idToken}');
      debugPrint(
          'auth response access: ${authorizationTokenResponse?.accessToken}');
      debugPrint(
          'auth response exp: ${authorizationTokenResponse?.accessTokenExpirationDateTime}');
      debugPrint(
          'auth response refresh: ${authorizationTokenResponse?.refreshToken}');
      debugPrint(
          'auth response token type: ${authorizationTokenResponse?.tokenType}');
      debugPrint(
          'auth response scopes: ${authorizationTokenResponse?.scopes.toString()}');
      debugPrint(
          'auth response token additional params: ${authorizationTokenResponse?.tokenAdditionalParameters.toString()}');

      return ResponseWrapper.success(authorizationTokenResponse!);
    } catch (e) {
      debugPrint('Exceptionnnnnnnn');
      return ResponseWrapper.error(400, 'lỗi rồi, app như lz');
    }
  }
}

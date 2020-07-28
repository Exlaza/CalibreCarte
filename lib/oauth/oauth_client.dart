import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:calibre_carte/oauth/access_token_response.dart';
import 'package:calibre_carte/oauth/authorization_response.dart';
import 'package:calibre_carte/oauth/oauth_pkce_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:random_string/random_string.dart';

class OAuth2Client {
  String redirectUri;
  String codeChallenge;
  String codeVerifier;
  String customUriScheme;
  Map<String, String> _accessTokenRequestHeaders;

  String authorizeUrl;
  String tokenUrl;

  String refreshUrl;
  String revokeUrl;

  OAuth2Client(
      {@required this.redirectUri,
      this.codeVerifier,
      @required this.authorizeUrl,
      @required this.tokenUrl,
      this.refreshUrl,
      this.revokeUrl});

  Future<AccessTokenResponse> getTokenFromAuthCodeFlow({
    @required String clientID,
    List<String> scopes,
    bool enablePKCE = true,
    String state,
    String codeVerifier,
    Function afterAuthorizationCodeCb,
    Map<String, dynamic> authCoedParams,
    Map<String, dynamic> accessTokenParams,
    httpClient,
  }) async {
    AccessTokenResponse tokenResponse;

    if (enablePKCE) {
      codeVerifier ??= OAuthPKCEUtils.generateCodeVerifier();

      codeChallenge = OAuthPKCEUtils.generateCodeChallenge(codeVerifier);
    }

    var authResp = await requestAuthorization(
        clientID: clientID, scopes: scopes, codeChallenge: codeChallenge);

    if (authResp.isAccessGranted()) {
      if (afterAuthorizationCodeCb != null) {
        afterAuthorizationCodeCb(authResp);
      }

      tokenResponse = await requestAccessToken(
          code: authResp.code, clientID: clientID, codeVerifier: codeVerifier);

    }

    return tokenResponse;

  }

  Future<AccessTokenResponse> requestAccessToken({
    @required String code,
    @required String clientID,
    String clientSecret,
    String codeVerifier,
    List<String> scopes,
    Map<String, dynamic> customParams,
  }) async {
    var httpClient = http.Client();

    final body = getTokenUrlParams(
        code: code,
        redirectUri: redirectUri,
        clientID: clientID,
        clientSecret: clientSecret,
        codeVerifier: codeVerifier,
        customParams: customParams);

    var response = await httpClient.post(tokenUrl,
        body: body, headers: _accessTokenRequestHeaders);

    return AccessTokenResponse.fromHttpResponse(response,
        requestedScopes: scopes);
  }

  set accessTokenRequestHeaders(Map<String, String> headers) {
    _accessTokenRequestHeaders = headers;
  }

  Map<String, dynamic> getTokenUrlParams(
      {@required String code,
      String redirectUri,
      String clientID,
      String clientSecret,
      String codeVerifier,
      Map<String, dynamic> customParams}) {
    final params = <String, dynamic>{
      'grant_type': 'authorization_code',
      'code': code
    };

    if (redirectUri != null && redirectUri.isNotEmpty) {
      params['redirect_uri'] = redirectUri;
    }

    if (clientID != null && clientID.isNotEmpty) {
      params['client_id'] = clientID;
    }

    if (clientSecret != null && clientSecret.isNotEmpty) {
      params['client_secret'] = clientSecret;
    }

    if (codeVerifier != null && codeVerifier.isNotEmpty) {
      params['code_verifier'] = codeVerifier;
    }

    if (customParams != null && customParams is Map) {
      params.addAll(customParams);
    }

    return params;
  }

  /// Requests an Authorization Code to be used in the Authorization Code grant.
  Future<AuthorizationResponse> requestAuthorization({
    @required String clientID,
    List<String> scopes,
    String codeChallenge,
    String state,
    Map<String, dynamic> customParams,
  }) async {
    state ??= randomAlphaNumeric(25);

    final authorizeUrl = getAuthorizeUrl(
        clientID: clientID,
        redirectUri: redirectUri,
        scopes: scopes,
        state: state,
        codeChallenge: codeChallenge,
        customParams: customParams);

//    Now I have to launch this authorised url in the system browser

    final result = await FlutterWebAuth.authenticate(
        callbackUrlScheme: customUriScheme, url: authorizeUrl);

    return AuthorizationResponse.fromRedirectUri(result, state);
  }

  String getAuthorizeUrl(
      {@required String clientID,
      String redirectUri,
      List<String> scopes,
      String state,
      String codeChallenge,
      Map<String, dynamic> customParams}) {
    final params = <String, dynamic>{
      'response_type': 'code',
      'client_id': clientID
    };

    if (redirectUri != null && redirectUri.isNotEmpty) {
      params['redirect_uri'] = redirectUri;
    }

    if (scopes != null && scopes.isNotEmpty) params['scope'] = scopes;

    if (state != null && state.isNotEmpty) params['state'] = state;

    if (codeChallenge != null && codeChallenge.isNotEmpty) {
      params['code_challenge'] = codeChallenge;
      params['code_challenge_method'] = 'S256';
    }

    if (customParams != null && customParams is Map) {
      params.addAll(customParams);
    }

    return OAuthPKCEUtils.addParamsToURL(authorizeUrl, params);
  }
}

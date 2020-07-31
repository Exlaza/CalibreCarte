import 'package:calibre_carte/oauth/access_token_response.dart';
import 'package:calibre_carte/oauth/oauth2_exception.dart';
import 'package:calibre_carte/oauth/oauth_client.dart';
import 'package:calibre_carte/oauth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class OAuth2Helper {
  final OAuth2Client client;

  TokenStorage tokenStorage;

  String clientID;

  List<String> scopes;

  Function afterAuthorisationCodeCb;

  Map<String, dynamic> authCodeParams;

  Map<String, dynamic> accessTokenParams;

  OAuth2Helper({
    @required this.client,
    @required this.clientID,
    this.scopes,
    this.accessTokenParams,
    this.afterAuthorisationCodeCb,
    this.authCodeParams,
  }) {
//Maybe I can use a different key here;
    tokenStorage = TokenStorage(key: client.tokenUrl);
  }

  Future<AccessTokenResponse> getToken() async {
    var tknResp = await getTokenFromStorage();

    if (tknResp != null) {
      if (tknResp.refreshNeeded()) {
        //The access token is expired
        tknResp = await refreshToken(tknResp.refreshToken);
      }
    } else {
//      GOTO HOMEPAGE SOMEHOW
    }

    if (tknResp != null && !tknResp.isBearer()) {
      throw Exception('Only Bearer tokens are currently supported');
    }

    return tknResp;
  }

  Future<AccessTokenResponse> getTokenFromStorage() async {
    return await tokenStorage.getToken();
  }

  Future<AccessTokenResponse> refreshToken(String refreshToken) async {
    AccessTokenResponse tknResp;

    tknResp = await client.refreshToken(refreshToken, clientId: clientID);

    if (tknResp == null) {
      throw OAuth2Exception('Unexpected error');
    } else if (tknResp.isValid()) {
      //If the response doesn't contain a refresh token, keep using the current one
      if (!tknResp.hasRefreshToken()) {
        tknResp.refreshToken = refreshToken;
      }
      await tokenStorage.addToken(tknResp);
    } else {
      if (tknResp.error == 'invalid_grant') {
        //The refresh token is expired too
        await tokenStorage.deleteToken();
        //Fetch another access token
//        Idhar we have to goto the home page. Or the settings page. This flow is undetermined.
      } else {
        throw OAuth2Exception(tknResp.error,
            errorDescription: tknResp.errorDescription);
      }
    }

    return tknResp;
  }

  Future<AccessTokenResponse> fetchToken() async {
    AccessTokenResponse tknResp;

    tknResp = await client.getTokenFromAuthCodeFlow(
        clientID: clientID, scopes: scopes);

    if (tknResp != null && tknResp.isValid()) {
      await tokenStorage.addToken(tknResp);
    }

    return tknResp;
  }

  Future<http.Response> post(String url,
      {Map<String, String> headers, dynamic body, httpClient}) async {
    httpClient ??= http.Client();

    headers ??= {};

    http.Response resp;

    var tknResp = await getToken();

    try {
      headers['Authorization'] = 'Bearer ' + tknResp.accessToken;
      resp = await httpClient.post(url, body: body, headers: headers);

      if (resp.statusCode == 401) {
        if (tknResp.hasRefreshToken()) {
          tknResp = await refreshToken(tknResp.refreshToken);
        } else {
//          At this point in time I should just logout and redirect to settings or homepage
          throw OAuth2Exception('Unauthorised',
              errorDescription: 'Access and Refresh Token both expired');
        }

        if (tknResp != null) {
          headers['Authorization'] = 'Bearer ' + tknResp.accessToken;
          resp = await httpClient.post(url, body: body, headers: headers);
        }
      }
    } catch (e) {
      rethrow;
    }
    return resp;
  }

  Future<http.Response> get(String url,
      {Map<String, String> headers, httpClient}) async {
    httpClient ??= http.Client();

    headers ??= {};

    http.Response resp;

    var tknResp = await getToken();

    try {
      headers['Authorization'] = 'Bearer ' + tknResp.accessToken;
      resp = await httpClient.get(url, headers: headers);

      if (resp.statusCode == 401) {
        if (tknResp.hasRefreshToken()) {
          tknResp = await refreshToken(tknResp.refreshToken);
        } else {
          throw OAuth2Exception('Unauthorised',
              errorDescription: 'Access and Refresh Token both expired');
        }

        if (tknResp != null) {
          headers['Authorization'] = 'Bearer ' + tknResp.accessToken;
          resp = await httpClient.get(url, headers: headers);
        }
      }
    } catch (e) {
      rethrow;
    }

    return resp;
  }
}

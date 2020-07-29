import 'package:calibre_carte/oauth/access_token_response.dart';
import 'package:calibre_carte/oauth/oauth2_exception.dart';
import 'package:calibre_carte/oauth/oauth_client.dart';
import 'package:calibre_carte/oauth/token_storage.dart';
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
}

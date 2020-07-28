import 'package:flutter/material.dart';

class OAuth2Client {
  String redirectUri;
  String codeChallenge;
  String codeVerifier;
  String codeChallengeMethod = 'S256';

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

  Future<AccessTokenResponse> getTokenFromAuthCodeFlow(){
    AccessTokenResponse
  }



}

import 'package:calibre_carte/oauth/oauth_client.dart';
import 'package:flutter/cupertino.dart';

class OAuth2Helper {
  final OAuth2Client client;

  TokenStorage tokenStorage;

  String clientID;

  List<String> scopes;

  Function afterAuthorisationCodeCb;

  Map<String, dynamic> authCodeParams;

  Map<String, dynamic> accessTokenParams;

  OAuth2Helper(
      {@required this.client,
      @required this.clientID,
      this.scopes,
      this.accessTokenParams,
      this.afterAuthorisationCodeCb,
      this.authCodeParams,
      this.tokenStorage});



}

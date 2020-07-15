import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';


class OAuthUtils {
  static final Random _random = Random.secure();
  static const String codeChallengeMethod = "S256";
  static String codeVerifier;

  static String encodeCodeChallenge(Digest codeChallenge) {
    String encoded = base64Url.encode(codeChallenge.bytes).split('=')[0];
    return encoded;
  }

  static String _generateCodeVerifier() {
    int length = 50;
    String text = "";
    String allowed = "-._~ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    for (var i = 0; i < length; i++) {
      text += allowed[_random.nextInt(allowed.length-1)];
    }
    return text;
  }

  static Digest _generateCodeChallenge() {
    codeVerifier = _generateCodeVerifier();
    Digest codeChallenge = sha256.convert(utf8.encode(codeVerifier));
    return codeChallenge;
  }

  static generateAndEncodeCodeChallenge(){
    var codeChallenge = _generateCodeChallenge();
    return encodeCodeChallenge(codeChallenge);
  }


}
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class OAuthPKCEUtils {
  static final _random = Random.secure();

  static String generateCodeVerifier() {
    int length = 50;
    String text = "";
    String allowed = "-._~ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    for (var i = 0; i < length; i++) {
      text += allowed[_random.nextInt(allowed.length-1)];
    }
    return text;
  }

  static String generateCodeChallenge(String codeVerifier) {
    var bytes = utf8.encode(codeVerifier);

    var digest = sha256.convert(bytes);

    var codeChallenge = base64UrlEncode(digest.bytes);

    if (codeChallenge.endsWith('=')) {
      //Since code challenge must contain only chars in the range ALPHA | DIGIT | "-" | "." | "_" | "~"
      //many OAuth2 servers (read "Google") don't accept the "=" at the end of the base64 encoded string
      codeChallenge = codeChallenge.substring(0, codeChallenge.length - 1);
    }

    return codeChallenge;
  }

  static paramsToQueryString(Map params){
    final qsList = <String>[];

    params.forEach((k, v) {
      String val;
      if (v is List) {
        val = v.map((p) => p.trim()).join('+');
      } else {
        val = v.trim();
      }
      qsList.add(k + '=' + val);
    });

    return qsList.join('&');
  }

  static addParamsToURL(String url, Map params){
    var queryString = paramsToQueryString(params);

    if (queryString != null && queryString.isNotEmpty) {
      url = url + '?' + queryString;
    }

    return url;
  }

}
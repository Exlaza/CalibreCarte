import 'dart:convert';

import 'package:http/http.dart' as http;

class OAuth2Response {
  int httpStatusCode;
  String error;
  String errorDescription;
  String errorUri;

  OAuth2Response();

  OAuth2Response.fromMap(Map<String, dynamic> map) {
    httpStatusCode = map['http_status_code'];

    //Maybe in the error Description here we can write our own custom errors.
    if (map.containsKey('error') && map['error'] != null) {
      error = map['error'];
      errorDescription = map.containsKey('error_description')
          ? map['error_description']
          : null;

      errorUri = map.containsKey('errorUri') ? map['error_uri'] : null;
    }
  }

  factory OAuth2Response.fromHttpRequest(http.Response response) {
    OAuth2Response resp;

    if (response.statusCode != 404) {
      if (response.body != '') {
        resp = OAuth2Response.fromMap(jsonDecode(response.body));
      } else {
        resp = OAuth2Response();
      }
    } else {
      resp = OAuth2Response();
    }

    resp.httpStatusCode = response.statusCode;
    return resp;
  }

  Map<String, dynamic> toMap() {
    return {
      'http_status_code': httpStatusCode,
      'error': error,
      'errorDescription': errorDescription,
      'errorUri': errorUri
    };
  }

  bool isValid() {
    return httpStatusCode == 200 && (error == null || error.isEmpty);
  }

  @override
  String toString() {
    if (httpStatusCode == 200) {
      return 'Is Okay';
    } else {
      return 'HTTP' +
          httpStatusCode.toString() +
          '-' +
          (error ?? " ") +
          (errorDescription ?? " ");
    }
  }
}

class Configuration {
  final String clientID;

  Configuration({this.clientID = ""});

  factory Configuration.fromJson(Map<String, dynamic> jsonMap) {
    return Configuration(clientID: jsonMap["clientID"]);
  }
}
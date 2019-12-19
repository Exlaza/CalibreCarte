class ClientId {
  final String apiKey;
  ClientId({this.apiKey = ""});
  factory ClientId.fromJson(Map<String, dynamic> jsonMap) {
    return new ClientId(apiKey: jsonMap["api_key"]);
  }
}
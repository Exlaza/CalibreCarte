class Tags {
  int id;
  String name;

  Tags({this.id, this.name});

  static final columns = [
    "id",
    "name",
  ];

  //  Method to convert sqflite map to the model
  Tags.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
  }

}
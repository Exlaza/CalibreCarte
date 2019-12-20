class Data {
  int id;
  int book;
  String format;
  int uncompressed_size;
  String name;

  Data({this.id, this.book, this.format, this.uncompressed_size, this.name});

  static final columns = ["id", "book", "format", "uncompressed_size", "name"];

  //  Method to convert sqflite map to the model
  Data.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.book = map['book'];
    this.format = map['format'];
    this.uncompressed_size = map['uncompressed'];
    this.name = map['name'];
  }
}

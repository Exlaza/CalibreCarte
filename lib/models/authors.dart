class Authors {
  int id;
  String name;
  String sort;
  String link;

  Authors({this.id, this.name, this.sort, this.link});

  static final columns = [
    "id",
    "name",
    "sort",
    "link"
  ];


  //  Method to convert sqflite map to the model
  Authors.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.sort = map['sort'];
    this.link = map['link'];
  }
}
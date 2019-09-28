class Publishers {
  int id;
  String name;
  String sort;

  Publishers({this.id, this.name, this.sort});

  static final columns = [
    "id",
    "name",
    "sort",
  ];

  Publishers.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.sort = map['sort'];
  }

}
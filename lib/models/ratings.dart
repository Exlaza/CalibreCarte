class Ratings {
  int id;
  int rating;

  Ratings({this.id, this.rating});

  static final columns = [
    "id",
    "rating",
  ];

  Ratings.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.rating = map['rating'];
  }
}

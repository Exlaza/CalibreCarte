class BooksRatingLink {
  int id;
  int book;
  int rating;

  BooksRatingLink({
    this.id,
    this.book,
    this.rating,
  });

  static final columns = [
    "id",
    "book",
    "author",
  ];

//  Map toMap() {
//    Map map = {
//      "title": title,
//      "body": body,
//      "user_id": user_id,
//    };
//
//    if (id != null) {
//      map["id"] = id;
//    }
//
//    return map;
//  }

  BooksRatingLink.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.book = map['book'];
    this.rating = map['rating'];
  }
}

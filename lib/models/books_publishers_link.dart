class BooksPublisherLink {
  int id;
  int book;
  int publisher;

  BooksPublisherLink({
    this.id,
    this.book,
    this.publisher,
  });

  static final columns = [
    "id",
    "book",
    "publisher",
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

  BooksPublisherLink.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.book = map['book'];
    this.publisher = map['publisher'];
  }
}

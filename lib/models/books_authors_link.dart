class BooksAuthorsLink {
  int id;
  int book;
  int author;

  BooksAuthorsLink({
    this.id ,
    this.book,
    this.author,
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

  BooksAuthorsLink.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.book = map['book'];
    this.author = map['author'];
  }
}

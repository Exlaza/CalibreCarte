class Books {
  int id;
  String title;
  String sort;
  String timestamp;
  String pubdate;
  num series_index;
  String author_sort;
  String isbn;
  String lccn;

  String path;

  Books({
    this.id,
    this.title,
    this.sort,
    this.timestamp,
    this.pubdate,
    this.series_index,
    this.author_sort,
    this.isbn,
    this.lccn,
    this.path
  });

  static final columns = [
    "id",
    "title",
    "sort",
    "timestamp",
    "pubdate",
    "series_index",
    "author_sort",
    "isbn",
    "lccn",
    "path"
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

  Books.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.sort = map['sort'];
    this.timestamp = map['timestamp'];
    this.pubdate = map['pubdate'];
    this.series_index = map['series_index'];
    this.isbn = map['isbn'];
    this.lccn = map['lccn'];
    this.path = map['path'];
  }
}

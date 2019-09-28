class Comments {
    int id;
    int bookId;
    String text;

    Comments({this.id, this.bookId, this.text});

    static final columns = [
      "id",
      "bookId",
      "text",
    ];

    Comments.fromMapObject(Map<String, dynamic> map) {
      this.id = map['id'];
      this.bookId = map['bookId'];
      this.text = map['text'];
    }

}


class Comments {
    int id;
    int book;
    String text;

    Comments({this.id, this.book, this.text});

    static final columns = [
      "id",
      "book",
      "text",
    ];

    Comments.fromMapObject(Map<String, dynamic> map) {
      this.id = map['id'];
      this.book = map['book'];
      this.text = map['text'];
    }

}


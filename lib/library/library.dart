import 'package:flutter/cupertino.dart';

class Library {

  String id;
  String name;
  String path;

  Library(this.id, this.name, this.path);

  Library.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    path = map['path'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'path': path,
    };
  }

}
import 'package:flutter/material.dart';

class BooksList extends StatelessWidget {
  final List<Map> books = [
    {
      'author': 'Stephen Hawking',
      'title': 'A Brief History Of Time',
      'Genre': 'Science'
    },
    {'author': 'Chetan Bhagat', 'title': 'Half Girlfriend', 'Genre': 'Crap'},
    {'author': 'RK Narayan', 'title': 'Malgudi Days', 'Genre': 'Nostalgia'},
    {'author': 'S Chand', 'title': 'Biology', 'Genre': 'Textbook'},
    {'author': 'Team Edward', 'title': 'Twilight', 'Genre': 'Teen Crap'},
    {
      'author': 'Stephen Hawking',
      'title': 'A Brief History Of Time',
      'Genre': 'Science'
    },
    {'author': 'Chetan Bhagat', 'title': 'Half Girlfriend', 'Genre': 'Crap'},
    {'author': 'RK Narayan', 'title': 'Malgudi Days', 'Genre': 'Nostalgia'},
    {'author': 'S Chand', 'title': 'Biology', 'Genre': 'Textbook'},
    {'author': 'Team Edward', 'title': 'Twilight', 'Genre': 'Teen Crap'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          elevation: 10,
          margin: EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 5,
          ),
          child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueGrey,Colors.grey])),

            child: ListTile(
              title: Text(books[index]['title'],style:TextStyle(fontWeight: FontWeight.bold)),
              leading: CircleAvatar(
                radius: 50,
                child: ClipOval(child: new Image.asset('lib/assets/images/calibre_logo.png',fit: BoxFit.scaleDown,)),
              ),
              subtitle: Column(crossAxisAlignment:CrossAxisAlignment.start ,children:<Widget>[Text(books[index]['author'],style: TextStyle(fontWeight: FontWeight.bold)),Text(books[index]['Genre'])]),
              //trailing: Text(books[index]['Genre']),

            ),
          ),
        );
      },
      itemCount: books.length,
    );
  }
}
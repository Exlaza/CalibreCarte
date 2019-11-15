import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class BooksCarouselView extends StatelessWidget {
  final String filter;
  final List<Books> books;
  final List<Map<String, String>> authorNames;
  BooksCarouselView(this.filter,this.books,this.authorNames);
  @override
  Widget build(BuildContext context) {
    void viewBookDetails(int bookId) {
      print(bookId);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return BookDetailsScreen(
          bookId: bookId,
        );
      }));
    }
    return Container(
      child: Center(
        child: CarouselSlider(
            enlargeCenterPage: true,
            aspectRatio: 3.0,
            items:filter==null? books.map((i) {
              return new Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => viewBookDetails(i.id),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.black.withOpacity(0.5),
                        ),
                        child: BookDetailsCoverImage(i.id,i.path)
                    ),
                  );
                },
              );
            }).toList():books
                .where((book) =>
                book.title.toLowerCase().contains(filter.toLowerCase()))
                .toList()
                .map((i) {
              return new Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => viewBookDetails(i.id),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.black.withOpacity(0.5),
                        ),
                        child: BookDetailsCoverImage(i.id,i.path)
                    ),
                  );
                },
              );
            }).toList(),
            height: 400.0,
            autoPlay: false,
          enableInfiniteScroll: false,
        ),
      ),
    );  }
}

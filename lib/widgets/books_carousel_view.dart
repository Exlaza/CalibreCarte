import 'package:calibre_carte/models/books.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/book_details_screen.dart';
import 'package:calibre_carte/widgets/book_details_cover_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class BooksCarouselView extends StatelessWidget {
  final String filter;
  final List<Books> books;
  BooksCarouselView(this.filter,this.books);
  @override
  Widget build(BuildContext context) {
    Update update=Provider.of(context);
    void viewBookDetails(int bookId) {
      print(bookId);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return BookDetailsScreen(
          bookId: bookId,
        );
      }));
    }
    return update.searchFilter=='author'?Container(
      child: Center(
        child: CarouselSlider(
          enlargeCenterPage: true,
          aspectRatio: 3.0,
          items:filter==null? books.map((i) {
            return new Builder(
              builder: (BuildContext context) {
                return Container(key: Key(i.id.toString()),
                  child: GestureDetector(
                    onTap: () => viewBookDetails(i.id),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.black.withOpacity(0.5),
                        ),
                        child: Container(child: BookDetailsCoverImage(i.id,i.path),key: Key(i.title),)
                    ),
                  ),
                );
              },
            );
          }).toList():books
              .where((book) =>
              book.author_sort.toLowerCase().contains(filter.toLowerCase()))
              .toList()
              .map((i) {
            return new Builder(
              builder: (BuildContext context) {
                return Container(key: Key(i.id.toString()),
                  child: GestureDetector(
                    onTap: () => viewBookDetails(i.id),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.black.withOpacity(0.5),
                        ),
                        child:Container(child: BookDetailsCoverImage(i.id,i.path),key: Key(i.title),)
                    ),
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
    ):Container(
      child: Center(
        child: CarouselSlider(
          enlargeCenterPage: true,
          aspectRatio: 3.0,
          items:filter==null? books.map((i) {
            return new Builder(
              builder: (BuildContext context) {
                return Container(key: Key(i.hashCode.toString()),
                  child: GestureDetector(
                    onTap: () => viewBookDetails(i.id),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.black.withOpacity(0.5),
                        ),
                        child: Container(child: BookDetailsCoverImage(i.id,i.path),key: Key(i.author_sort),)
                    ),
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
                return Container(key: Key(i.hashCode.toString()),
                  child: GestureDetector(
                    onTap: () => viewBookDetails(i.id),
                    child: Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:Colors.black.withOpacity(0.5),
                        ),
                        child:Container(child: BookDetailsCoverImage(i.id,i.path),key: Key(i.author_sort),)
                    ),
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

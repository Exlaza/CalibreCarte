import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  final String title;
  final String author;
  final String description



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                    'https://nearst-product-images.s3-eu-west-1.amazonaws.com/f6128169-c96b-4071-a349-9029bf6963f0.jpg'),
              ),
              DefaultTabController(
                  // The number of tabs / content sections to display.
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TabBar(
                          unselectedLabelColor: Colors.black,
                          labelColor: Colors.black,
                          tabs: [
                            Tab(icon: Icon(Icons.directions_car), text: 'Meta',),
                            Tab(icon: Icon(Icons.directions_transit), text: 'Description',),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: TabBarView(
                          children: [
                            Icon(Icons.directions_car),
                            Icon(Icons.directions_transit),
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

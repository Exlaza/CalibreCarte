import 'package:flutter/material.dart';

class BookDetailsScreen extends StatelessWidget {
  static const routeName = '/book-details';
//  final String title;
//  final String author;
//  final String description;
//
//  BookDetailsScreen({this.title, this.author, this.description});

  final String description =
      """A young woman walks into a laboratory. Over the past two years, she has transformed almost every aspect of her life. She has quit smoking, run a marathon, and been promoted at work. The patterns inside her brain, neurologists discover, have fundamentally changed.

Marketers at Procter & Gamble study videos of people making their beds. They are desperately trying to figure out how to sell a new product called Febreze, on track to be one of the biggest flops in company history. Suddenly, one of them detects a nearly imperceptible pattern—and with a slight shift in advertising, Febreze goes on to earn a billion dollars a year.

An untested CEO takes over one of the largest companies in America. His first order of business is attacking a single pattern among his employees—how they approach worker safety—and soon the firm, Alcoa, becomes the top performer in the Dow Jones.

What do all these people have in common? They achieved success by focusing on the patterns that shape every aspect of our lives.

They succeeded by transforming habits.

In The Power of Habit, award-winning New York Times business reporter Charles Duhigg takes us to the thrilling edge of scientific discoveries that explain why habits exist and how they can be changed. With penetrating intelligence and an ability to distill vast amounts of information into engrossing narratives, Duhigg brings to life a whole new understanding of human nature and its potential for transformation.

Along the way we learn why some people and companies struggle to change, despite years of trying, while others seem to remake themselves overnight. We visit laboratories where neuroscientists explore how habits work and where, exactly, they reside in our brains. We discover how the right habits were crucial to the success of Olympic swimmer Michael Phelps, Starbucks CEO Howard Schultz, and civil-rights hero Martin Luther King, Jr. We go inside Procter & Gamble, Target superstores, Rick Warren’s Saddleback Church, NFL locker rooms, and the nation’s largest hospitals and see how implementing so-called keystone habits can earn billions and mean the difference between failure and success, life and death.

At its core, The Power of Habit contains an exhilarating argument: The key to exercising regularly, losing weight, raising exceptional children, becoming more productive, building revolutionary companies and social movements, and achieving success is understanding how habits work.

Habits aren’t destiny. As Charles Duhigg shows, by harnessing this new science, we can transform our businesses, our communities, and our lives. """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                            Tab(
                              icon: Icon(Icons.directions_car),
                              text: 'Meta',
                            ),
                            Tab(
                              icon: Icon(Icons.description),
                              text: 'Description',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 250,
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  child: Text(description),
                                )),
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

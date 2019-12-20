import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "About Calibre Carte",
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        ),
        backgroundColor: Color(0xff002242),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
//                decoration: BoxDecoration(
//                    border: Border.all(width: 2, color: Color(0xffFED962))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Authors: ",
                      style: TextStyle(
                          fontFamily: 'Montserrat', color: Colors.grey, fontSize: 25),
                    ),SizedBox(height: 20,),
                    Text("Ekansh Jain, Prerna Dave",style: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.black, fontSize: 20))
                  ],
                ),
              ), SizedBox(height: 40,),Container(
//                decoration: BoxDecoration(
//                    border: Border.all(width: 2, color: Color(0xffFED962))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Contact: ",
                      style: TextStyle(
                          fontFamily: 'Montserrat', color: Colors.grey, fontSize: 25),
                    ),SizedBox(height: 20,),
                    Text("calibre.carte@gmail.com",style: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.black, fontSize: 20))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

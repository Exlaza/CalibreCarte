import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  final points = [
    "Calibre Carte does not collect any of your personal information or track a user in any way. ",
    "When you connect to Dropbox, and use the app, data is sent to and requested from Dropbox, which is governed by its own privacy policy. Dropbox is not affiliated with Calibre Carte, and as such, anything that it does or does not do with your data is completely out of this app’s control.",
    "Calibre Carte runs on top of Calibre, which is governed by its own privacy policy. Calibre is not affiliated with Calibre Carte, and as such, anything that it does or does not do with your data is completely out of Calibre Carte's control.",
    "If you use the ebook download / export feature, the e-book file will leave the app and be opened in the app of your choice. The apps that can open these files are not affiliated with Calibre Carte, and each have their own privacy policies."
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        ),
        backgroundColor: Color(0xff002242),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: points[0],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15))
                    ]),
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              "When you connect to Dropbox, and use the app, data is sent to and requested from",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15)),
                      TextSpan(
                          text: " Dropbox",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://dropbox.com/');
                            },
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.blue,
                              fontSize: 15)),
                      TextSpan(
                          text:
                              ", which is governed by its own privacy policy. Dropbox is not affiliated with Calibre Carte, and as such, anything that it does or does not do with your data is completely out of this app’s control.",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15))
                    ]),
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                          "Calibre Carte runs on top of",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15)),
                      TextSpan(
                          text: " Calibre",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch('https://calibre-ebook.com/');
                            },
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.blue,
                              fontSize: 15)),
                      TextSpan(
                          text:
                          ", which is governed by its own privacy policy. Calibre is not affiliated with Calibre Carte, and as such, anything that it does or does not do with your data is completely out of Calibre Carte's control.",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15))
                    ]),
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: points[3],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 15))
                    ]),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

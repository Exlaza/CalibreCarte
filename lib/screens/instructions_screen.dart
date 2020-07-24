import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme = Provider.of(context);
    return Scaffold(
      backgroundColor: colorTheme.descriptionBackground,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Instructions",
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white),
        ),
        backgroundColor: colorTheme.appBarColor,
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorTheme.headerText),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              " Before logging in, you should upload your entire Calibre Library folder to dropbox. You can find the location of the folder by clicking on the \"Calibre Library\" button in the Calibre Application.",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: colorTheme.headerText,
                              fontSize: 15))
                    ]),
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorTheme.headerText),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              " You can read more about how to export and move Calibre's libraries ",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: colorTheme.headerText,
                              fontSize: 15)),
                      TextSpan(
                          text: "here.",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'http://blog.calibre-ebook.com/2017/01/how-to-backup-move-and-export-your.html');
                            },
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.blue,
                              fontSize: 15)),
                    ]),
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "\u2022",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorTheme.headerText),
                  ),
                  Expanded(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text:
                              " For the best experience with Calibre Carte, download e-book metadata and covers using Calibre. You can find the instructions to download and edit metadata",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: colorTheme.headerText,
                              fontSize: 15)),
                      TextSpan(
                          text: " here.",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(
                                  'https://manual.calibre-ebook.com/metadata.html#id2');
                            },
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.blue,
                              fontSize: 15)),
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

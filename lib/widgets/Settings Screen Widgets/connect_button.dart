import 'dart:io';

import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ConnectButton extends StatelessWidget {
  Function connect;
  ConnectButton(this.connect);
  Future<bool> checkNet() async {
    try {
      var result = await InternetAddress.lookup('www.google.com');
//      print("internet is $result");
      return true;
    } on SocketException catch (_) {
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    ColorTheme colorTheme= Provider.of(context);
    return InkWell(
      onTap: connect,
      child: Container(
        padding: EdgeInsets.fromLTRB(50, 10, 20, 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.cloud_queue,
                  color: Color(0xffFED962),
                ),
                SizedBox(
                  width: 10,
                ),
                Text("Connect Dropbox",
                    style: TextStyle(
                        fontFamily: 'Montserrat', fontSize: 13,color: colorTheme.headerText))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

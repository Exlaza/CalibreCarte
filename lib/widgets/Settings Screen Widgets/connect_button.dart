import 'package:flutter/material.dart';
class ConnectButton extends StatelessWidget {
  Function connect;
  ConnectButton(this.connect);
  @override
  Widget build(BuildContext context) {
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
                        fontFamily: 'Montserrat', fontSize: 13))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

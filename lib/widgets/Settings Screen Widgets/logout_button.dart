import 'dart:math';

import 'package:flutter/material.dart';
class LogoutButton extends StatelessWidget {
  Function logout;
  LogoutButton(this.logout);
  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 0.0,
      child: InkWell(
        onTap: logout,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    color: Color(0xffFED962),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Logout",
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 15))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

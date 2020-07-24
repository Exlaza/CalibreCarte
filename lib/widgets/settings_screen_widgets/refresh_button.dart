import 'package:calibre_carte/helpers/metadata_cacher.dart';
import 'package:calibre_carte/providers/color_theme_provider.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshButton extends StatelessWidget {
  Function logout;

  RefreshButton(this.logout);

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);
    ColorTheme colorTheme = Provider.of(context);
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      child: InkWell(
        onTap: () {
          showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                        key: UniqueKey(),
                        backgroundColor: Colors.black54,
                        children: <Widget>[
                          Center(
                            child: Column(children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Refreshing library",
                                style: TextStyle(color: Colors.blueAccent),
                              )
                            ]),
                          )
                        ]));
              });

          Future<int> m = MetadataCacher().downloadAndCacheMetadata();

          m.then((value) {
            if (value == 1) {
//                                print("Donwloading finished");
              update.updateFlagState(true);
              Navigator.of(context).pop();
            } else {
              if (value == 0) {
                Navigator.of(context).pop();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("No internet"),
                ));
              } else {
                Navigator.of(context).pop();
                logout();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Authentication expired. Please login again"),
                ));
              }
            }
          });

//                            Showing a dialog till the snackbar thing works

//                            TODO: This is not working.
          FutureBuilder(
            future: m,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return null;
              } else {
                return SnackBar(
                  content: Text("Refreshing..."),
                  backgroundColor: Colors.grey.withOpacity(0.7),
                );
              }
            },
          );
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(46, 1, 20, 0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.refresh,
                    color: colorTheme.settingsIcon,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Refresh library",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          color: colorTheme.headerText))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:calibre_carte/screens/dropbox_signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropboxSignIn extends StatefulWidget {
  static const clientID = 'xw6prhzsxxtkza1';
  static const redirectUri = 'calibrecarte://dropbox';

  @override
  _DropboxSignInState createState() => _DropboxSignInState();
}

class _DropboxSignInState extends State<DropboxSignIn> {
  Future myFuture;
  String dropboxEmail;
  String selected_calibre_lib_dir;
  List<String> calibre_dirs;
  int noOfCalibreLibs;

  Future<bool> loadingToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey('token')){
      dropboxEmail = sp.getString('dropboxEmail');
      selected_calibre_lib_dir = sp.getString('selected_calibre_lib_dir');
      noOfCalibreLibs = sp.getInt('noOfCalibreLibs');
      for(int i = 0; i<noOfCalibreLibs; i++){
        calibre_dirs[i] = sp.getString('calibre_dirs_$i');
      }
      return true;
    }

    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Hitting it');
    myFuture = loadingToken();
  }

  final url =
      'https://www.dropbox.com/oauth2/authorize?client_id=${DropboxSignIn.clientID}&response_type=token&redirect_uri=${DropboxSignIn.redirectUri}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing it ot"),
      ),
      body: FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == false) {
              return Center(
                  child: RaisedButton(
                      child: Text('Connect Dropbox'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DropboxAuthentication(
                            selectedUrl: url,
                          );
                        }));
                      }));
            } else {
              return Text('HulaHoop');
            }
          } else {
            return Text('Hula hoop');
          }
        },
      ),
    );
  }
}

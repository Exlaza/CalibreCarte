import 'package:calibre_carte/providers/update_provider.dart';
import 'package:calibre_carte/screens/connect_dropbox_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  SharedPreferences _prefs;
  bool darkMode;
  Future myFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = SharedPreferences.getInstance();
    myFuture.then((sp) {
      _prefs = sp;
      darkMode = sp.getBool('darkMode') ?? false;
    });
  }

  void saveBoolToSharedPrefs(String settingName, bool val) {
    _prefs.setBool(settingName, val);
  }

  void saveStringToSP(String settingName, String val) {
    _prefs.setString(settingName, val);
  }

//  I needed to save Future builder in an instance because that was the only way, to prevent Future builder from firing again and again
//  Here's the thing. If you give it a function the future: property in future builder assumes that you are returning a new instance of future
//  For future builder this is akin to saying build it again
//  I don't want to build Future builder again, just the switch component part of the already shown widget.
//  This is a very subtle distinction which took 2 hrs of google searching to finally figure out what was wrong
//  One more error that you have to take care of is that a value in switch bool should not be None. There is a possibility that
//  While returning from shared preferences, you get the yellow screen if that is None

//  I cannot delegate it to a variable above the return statement because this will lead to the yellow scren becuse flutter tries to build that before it goes to the return
//  Part of the
//  And while the build is definitely called. We don't update the whole page, becuase the future builder know the future returned
//  Has not changed
//  So we can also shave a few miliseconds from that if we

  @override
  Widget build(BuildContext context) {
//    print('Building asettings for no reason');
    Widget loadingWidget = Center(
      child: CircularProgressIndicator(),
    );
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/images/subtle_wood.png',
          fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black.withOpacity(0.5),
            title: Text('Settings'),
          ),
          body: FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
//                print('THe connection finished now');
                return Container(
                  margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            'Cloud',
                            style: TextStyle(fontSize: 30),
                          )),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          onTap: () {
//                            print('Tap is not working');
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DropboxSignIn();
                            }));
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(Icons.cloud),
                                    Text('Dropbox'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Search',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Consumer<Update>(
                        builder:
                        (ctx,update,child)=>Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            children: <Widget>[
                              ListTile(trailing: Text(update.searchFilter??'not selected'),
                                leading: Icon(Icons.search),
                                title: Text(
                                  "Search By",
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0)),
                                      backgroundColor:
                                      Colors.grey.withOpacity(0.8),
                                      context: context,
                                      builder: (_) {
                                        return Container(
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                title: Text("Author"),
                                                onTap: (){
                                                  saveStringToSP('searchFilter', 'author');
                                                  update.changeSearchFilter('author');
                                                },
                                              ),
                                              ListTile(
                                                title: Text("Book Title"),
                                                onTap: (){
                                                  saveStringToSP('searchFilter', 'title');
                                                  update.changeSearchFilter('title');
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                              )
//                              Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Icon(
//                                        Icons.settings_ethernet,
//                                        size: 20,
//                                      ),
//                                      SizedBox(
//                                        width: 30,
//                                      ),
//                                      Text(
//                                        'Search Title',
//                                        style: TextStyle(fontSize: 20),
//                                      ),
//                                    ],
//                                  ),
//                                  Switch(
//                                    value: searchTitle,
//                                    onChanged: (val) {
//                                      saveSettingsToSharedPrefs(
//                                          'searchTitle', val);
//                                      setState(() {
//                                        searchTitle = val;
//                                      });
//                                    },
//                                  )
//                                ],
//                              ),
//                              Row(
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Row(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Icon(
//                                        Icons.settings_ethernet,
//                                        size: 20,
//                                      ),
//                                      SizedBox(
//                                        width: 30,
//                                      ),
//                                      Text(
//                                        'Search Title',
//                                        style: TextStyle(fontSize: 20),
//                                      ),
//                                    ],
//                                  ),
//                                  Switch(
//                                    value: searchAuthor,
//                                    onChanged: (val) {
//                                      saveSettingsToSharedPrefs(
//                                          'searchAuthor', val);
//                                      setState(() {
//                                        searchAuthor = val;
//                                      });
//                                    },
//                                  )
//                                ],
//                              ),
                            ],
                          ),
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'Other',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.wb_sunny,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Dark Mode',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: darkMode,
                                    onChanged: (val) {
                                      saveBoolToSharedPrefs(
                                          'darkMode', val);
                                      setState(() {
                                        darkMode = val;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
//                print('The connection hasn\'t finsihed yet');
                return CircularProgressIndicator();
              }
            },
          ),
        )
      ],
    );
  }
}

class SearchSettingRowTrigger extends StatelessWidget {
  final bool boolTriggerValue;

  SearchSettingRowTrigger(this.boolTriggerValue);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(
          Icons.settings_ethernet,
        ),
        Text('Search Title'),
        Switch(
          value: boolTriggerValue,
          onChanged: (val) {},
        )
      ],
    );
  }
}

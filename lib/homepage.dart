import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/books_view.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String layout = "list";
  TextEditingController controller = new TextEditingController();
  String filter;
  String sortOption = "title";
  String sortDirection = "asc";
  String token;
  Future myFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    myFuture = getTokenFromPreferences();
  }

  Future<void> getTokenFromPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    token = sp.getString('token');
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey.withOpacity(0.8),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.apps),
                  title: new Text(
                    'Layout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => {showLayouts(context)},
                ),
                ListTile(
                  leading: new Icon(Icons.sort),
                  title: new Text('Sort',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => {showSortOptions(context)},
                ),
                ListTile(
                  leading: new Icon(Icons.settings),
                  title: new Text('Settings',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () => showSettings(context),
                )
              ],
            ),
          );
        });
  }

  showSettings(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, "/settings").then((_){
      setState(() {
        myFuture = getTokenFromPreferences();
      });
    });
  }

  void showLayouts(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey.withOpacity(0.8),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text("List"),
                  onTap: () {
                    setState(() {
                      layout = "list";
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.grid_on),
                  title: Text("Grid"),
                  onTap: () {
                    setState(() {
                      layout = "grid";
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_carousel),
                  title: Text("Carousel"),
                  onTap: () {
                    setState(() {
                      layout = "carousel";
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  void showSortOptions(BuildContext context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey.withOpacity(0.8),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.title),
                  title: Text("Title"),
                  onTap: () {
                    showSortDirectionOptions("title");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.alternate_email),
                  title: Text("Author Name"),
                  onTap: () {
                    showSortDirectionOptions("author");
                  },
                ),
              ],
            ),
          );
        });
  }

  void showSortDirectionOptions(String sortOpt) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        backgroundColor: Colors.grey.withOpacity(0.8),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.keyboard_arrow_up),
                  title: Text("Ascending"),
                  onTap: () {
                    setState(() {
                      sortOption = sortOpt;
                      sortDirection = "asc";
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.keyboard_arrow_down),
                  title: Text("Descending"),
                  onTap: () {
                    setState(() {
                      sortOption = sortOpt;
                      sortDirection = "desc";
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget closeButton() {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        _appBarTitle = Text("Calibre Carte");
        controller.clear();
      },
    );
  }

  void _searchPressed() {
    setState(() {
      _appBarTitle = new TextField(
        controller: controller,
        decoration: new InputDecoration(
            prefixIcon: closeButton(), hintText: 'Search...'),
      );
    });
  }

  Widget _appBarTitle = const Text("Calibre Carte");

  @override
  Widget build(BuildContext context) {
    print("rebuilding homepage");

    return Container(
      child: Stack(
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
                  backgroundColor: Colors.black.withOpacity(0.6),
                  title: _appBarTitle,
                  leading:
                      Image.asset('assets/images/calibre_logo.png', scale: 0.4),
                  actions: <Widget>[
                    // action button
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchPressed();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        _settingModalBottomSheet(context);
                      },
                    )
                  ]),
              body: FutureBuilder(
                  future: myFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (token != null){
                        return BooksView(
                          layout,
                          filter,
                          sortDirection: sortDirection,
                          sortOption: sortOption,
                        );
                      }else{
                        return Center(child: Text('Please Connect to dropbox'),);
                      }

                    } else {
                      return CircularProgressIndicator();
                    }
                  })),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'books_list.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _layout = "list";

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(elevation: 5,
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
            onTap: () =>
            {
              showLayouts(context)
            },
          ),
          ListTile(
          leading: new Icon(Icons.sort_by_alpha),
          title: new Text('Sort',
          style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () => {},
          ),
          ListTile(
          leading: new Icon(Icons.settings),
          title: new Text('Settings',
          style: TextStyle(fontWeight: FontWeight.bold)),
          onTap:()=> showSettings(context)
          ,)
          ]
          ,
          )
          ,
          );
        });
  }
showSettings(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.pushNamed(context,"/settings");
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
                      _layout = "list";
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.grid_on),
                  title: Text("Grid"),
                  onTap: () {
                    setState(() {
                      _layout = "grid";
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_carousel),
                  title: Text("Carousel"),
                  onTap: () {},
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
                title: const Text("Calibre Carte"),
                leading:
                Image.asset('assets/images/calibre_logo.png', scale: 0.4),
                actions: <Widget>[
                  // action button
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                  )
                ]),
            body: BooksList(),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class DropboxAuthentication extends StatefulWidget {
  final String selectedUrl;

  DropboxAuthentication({
    @required this.selectedUrl,
  });

  @override
  _DropboxAuthenticationState createState() =>
      _DropboxAuthenticationState(selectedUrl);
}

class _DropboxAuthenticationState extends State<DropboxAuthentication> {
  final url;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isLoadingPage;
  final key = UniqueKey();
  num _stackToView = 1;

  StreamSubscription _sub;

  Future<Null> initUniLinks() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = getLinksStream().listen((String link) {
      //Althouhg this is not needed now, but Google actually recommends against using a webview for,
      //So assuming in future we need to do it the url_launcher way then we would have to use this method
      print(link);
      //So, just keeping it here.
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  //Let's try and figure out if I can attach a listener and then parse and do something when I finally get a URL back

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sub.cancel();
  }

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  _DropboxAuthenticationState(this.url);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoadingPage = true;
    initUniLinks();
  }

  _launchURL(String url) async{
    print(await canLaunch(url));
    if (await canLaunch(url)) {
      print('url');
      await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropbox Login'),
      ),
      body: IndexedStack(
        index: _stackToView,
        children: <Widget>[
          WebView(
            key: key,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.selectedUrl,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request)
            {
              if (request.url.startsWith('calibrecarte://dropbox'))
              {
                _launchURL(request.url);
                //Here you parse the url and get back the token value and send it wherever or store it in some state
                Navigator.pop(context);
                return NavigationDecision.prevent;
              }

              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageFinished: _handleLoad,
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

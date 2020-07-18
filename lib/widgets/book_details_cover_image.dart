import 'dart:io';
import 'dart:async';

import 'package:calibre_carte/helpers/cache_invalidator.dart';
import 'package:calibre_carte/homepage.dart';
import 'package:calibre_carte/providers/update_provider.dart';
import 'package:flutter/material.dart';
import 'package:calibre_carte/helpers/image_cacher.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetailsCoverImage extends StatefulWidget {
  final int bookId;
  final String relativePath;
  final height;
  final width;

  BookDetailsCoverImage(
      this.bookId, this.relativePath, this.height, this.width);

  @override
  _BookDetailsCoverImageState createState() => _BookDetailsCoverImageState();
}

class _BookDetailsCoverImageState extends State<BookDetailsCoverImage> {
  Future myFuture;
  String localImagePath;
  Future<int> gotImage;

  Future<int> getBookCoverImage() async {
    ImageCacher ic = ImageCacher();
    int imageExists = 200;

    bool exists =
        await ic.checkIfCachedFileExists(widget.relativePath, widget.bookId);
    if (!exists) {
      imageExists =
          await ic.downloadAndCacheImage(widget.relativePath, widget.bookId);
    }
    if (imageExists == 200) {
      localImagePath =
          await ic.returnCachedImagePath(widget.relativePath, widget.bookId);
      return imageExists;
    }
    if (imageExists == 401) {
      return imageExists;
    }
    return imageExists;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gotImage = getBookCoverImage();
  }

  Future<void> deleteToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    Update update = Provider.of(context);

    return FutureBuilder(
      future: gotImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 401) {
            deleteToken();
            CacheInvalidator.invalidateImagesCache();
            CacheInvalidator.invalidateDatabaseCache();
            update.changeTokenState(false);
            update.updateFlagState(true);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MyHomePage();
            }));
          }
          if (snapshot.data == 200) {
            print("image download response");
            print(gotImage);
            return widget.height == null
                ? Image.file(
                    File(localImagePath),
                    key: UniqueKey(),
                  )
                : Image.file(
                    File(localImagePath),
                    key: UniqueKey(),
                    height: widget.height,
                    width: widget.width,
                    fit: BoxFit.fill,
                  );
          } else {
            return widget.height == null
                ? Image.asset('assets/images/logo.png',
                    key: UniqueKey(),
                    height: widget.height,
                    width: widget.width,
                    fit: BoxFit.fitWidth)
                : Image.asset('assets/images/logo.png',
                    height: widget.height,
                    width: widget.width,
                    fit: BoxFit.fitWidth);
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

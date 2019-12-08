import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:calibre_carte/helpers/image_cacher.dart';

class BookDetailsCoverImage extends StatefulWidget {
  final int bookId;
  final String relativePath;

  BookDetailsCoverImage(this.bookId, this.relativePath);

  @override
  _BookDetailsCoverImageState createState() => _BookDetailsCoverImageState();
}

class _BookDetailsCoverImageState extends State<BookDetailsCoverImage> {
  Future myFuture;
  String localImagePath;
  Future<bool> gotImage;

  Future<bool> getBookCoverImage() async {
    ImageCacher ic = ImageCacher();
    bool imageExists = true;

    bool exists = await ic.checkIfCachedFileExists(widget.bookId);
    if (!exists) {
      imageExists =
          await ic.downloadAndCacheImage(widget.relativePath, widget.bookId);
    }
    if (imageExists == true) {
      localImagePath = await ic.returnCachedImagePath(widget.bookId);
      return true;
    }
    if (imageExists == false) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gotImage = getBookCoverImage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gotImage,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Image.file(
              File(localImagePath),height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width/3.5,fit: BoxFit.fill,
            );
          } else
            return Image.asset('assets/images/calibre_logo.png', scale: 0.4);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

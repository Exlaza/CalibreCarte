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

  Future<void> getBookCoverImage() async {
    ImageCacher ic = ImageCacher();

    bool exists = await ic.checkIfCachedFileExists(widget.bookId);

    if (!exists) {
      await ic.downloadAndCacheImage(widget.relativePath, widget.bookId);
    }

    localImagePath = await ic.returnCachedImagePath(widget.bookId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getBookCoverImage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.file(File(localImagePath)),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

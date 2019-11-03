import 'dart:io';

import 'package:calibre_carte/helpers/image_cacher.dart';
import 'package:flutter/material.dart';
class GetBookThumbnail extends StatefulWidget {
  final int bookId;
  final String relativePath;
  GetBookThumbnail(this.bookId,this.relativePath);
  @override
  _GetBookThumbnailState createState() => _GetBookThumbnailState();
}

class _GetBookThumbnailState extends State<GetBookThumbnail> {
  Future myFuture;
  String localImagePath;

  Future<void> getBookCoverImage() async {
    ImageCacher ic = ImageCacher();

    bool exists = await ic.checkIfCachedFileExists(widget.bookId);

    if (!exists) {
      await ic.downloadAndCacheImageThumbnail(widget.relativePath, widget.bookId);
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
          return Image.file(File(localImagePath),fit: BoxFit.fitHeight);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

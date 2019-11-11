import 'package:flutter/material.dart';
class DownloadIcon extends StatefulWidget {
  @override
  _DownloadIconState createState() => _DownloadIconState();
}

class _DownloadIconState extends State<DownloadIcon> {
  Color color= Colors.black54;
  void _download(){
    setState(() {
      color=Colors.blue;
    });
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(Icons.file_download),color: color,onPressed: _download,);
  }
}

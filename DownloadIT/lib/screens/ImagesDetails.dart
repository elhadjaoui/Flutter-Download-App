
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit_video_downloader/screens/galleryScreen.dart';
import 'package:share_extend/share_extend.dart';

class Images extends StatefulWidget {
  final file;
  Images({this.file});
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  bool choice = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
              tag: "image",
              child: Image.file(widget.file,fit: choice ? BoxFit.fill : BoxFit.cover,)),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(icon: Icon(Icons.share),color: Colors.white, onPressed: (){
                        ShareExtend.share(widget.file.path, "video");
                      },),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(icon : Icon(Icons.delete),color: Colors.white, onPressed: ()async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Warning'),
                              content: Text(
                                  'Are you sure you want to delete this video. '),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: Navigator.of(context).pop,
                                ),
                                FlatButton(
                                    child: Text('Confirm'),
                                    onPressed: () {
                                      widget.file.delete();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GalleryScreen()));
                                    }),
                              ],
                            );
                          },
                        );
                        //  setState(() {});
                      },),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(choice ? Icons.fullscreen_exit : Icons.fullscreen),
                      onPressed: (){
                        setState(() {
                          choice = !choice;
                        });
                      },
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(height: 10.0),
//                  Hero(
//                    tag: "title$index",
//                    child: Material(
//                      type: MaterialType.transparency,
//                      child: Text(dummy[index]["title"], style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold
//                      ),),
//                    ),
//                  ),
//                  SizedBox(height: 20.0),
//                  Hero(
//                    tag: "price$index",
//                    child: Material(
//                      type: MaterialType.transparency,
//                      child: Text(dummy[index]['price'], textAlign: TextAlign.start, style: TextStyle(
//                        fontSize: 30.0,
//                        fontWeight: FontWeight.bold,
//                        color: Colors.white
//                      ),),
//                    ),
//                  ),
                SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}

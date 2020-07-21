import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:provider/provider.dart';

import 'package:photo_view/photo_view.dart';


class PagePhoto extends StatefulWidget{

  final BuildContext oldContext;
  PagePhoto(this.oldContext);

  @override
  State<StatefulWidget> createState() => PhotoState(oldContext);
}


class PhotoState extends State<PagePhoto> {

  final BuildContext oldContext;
  double opacity = 1.0;
  Photo image;

  PhotoState(this.oldContext) {
    image = Provider.of<Photo>(oldContext);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: image,
      builder: (context, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarOpacity: opacity,
            iconTheme: IconThemeData(
              color: Colors.white70
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  alertChangerDescription(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  alertSupprimerPhoto(context);
                },
              )
            ],
          ),
          extendBodyBehindAppBar: true,
          body: image.image == null
              ? Text(image.idPhoto.toString())
              : Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    GestureDetector(
                      child: PhotoView(
                        imageProvider: FileImage(image.image),
                        minScale: PhotoViewComputedScale.contained * 1.0,
                        maxScale: 4.0,
                      ),
                      onTap: () => setState(() {
                        opacity != 0.0 ? opacity = 0.0 : opacity = 1.0;
                      }),
                    ),
                    Opacity(
                      opacity: opacity,
                      child: Container(
                        color: Colors.black12.withOpacity(0.5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical, //.horizontal
                          child: Consumer<Photo>(
                            builder: (context, value, child) {
                              return Text(
                                value.description,
                                style: Theme.of(context).textTheme.bodyText1,
                              );
                            },
                          ),
                        ),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void alertChangerDescription(BuildContext context) {
    String newDescription = "";

    showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Changer la description"),
          content: TextField(
            onChanged: (value) => newDescription = value,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: TextEditingController(text: image.description),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                if (newDescription != "") {
                  image.setDescription(newDescription);
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  void alertSupprimerPhoto(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Supprimer la photo ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Provider.of<Collection>(oldContext, listen: false).supprimer(image);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}
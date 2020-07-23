import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:galerieapp/database.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AlertAjouterPhoto extends StatefulWidget{

  final BuildContext contextCollection;

  AlertAjouterPhoto(this.contextCollection);

  @override
  State<StatefulWidget> createState() => AlertAjouterPhotoState(contextCollection);
}

class AlertAjouterPhotoState extends State<AlertAjouterPhoto>{

  final BuildContext contextCollection;

  File image;
  String nouvelleDescription = "";
  DateTime date;

  AlertAjouterPhotoState(this.contextCollection);

  @override
  Widget build(BuildContext context) {

    Collection c = Provider.of<Collection>(contextCollection);

    return AlertDialog(
      scrollable: true,
      content: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              ImagePicker _picker = ImagePicker();
              PickedFile pickedImage =
                  await _picker.getImage(source: ImageSource.gallery);
              if (pickedImage != null) {
                image = File(pickedImage.path);
                setState(() {});
              }
            },
            child: Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width/2,
                height: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: image == null
                      ? Icon(Icons.add_a_photo)
                      : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => nouvelleDescription = value,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            padding: EdgeInsets.only(top: 5, bottom: 5,),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
               date==null ? Text("") : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      date = null;
                    });
                  },
                ),
                Text(date==null ? "" : date.toString().substring(0,10)),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      DatePicker.showDatePicker(context,
                        currentTime: DateTime.now(),
                        minTime: DateTime(1900, 1),
                        maxTime: DateTime.now(),
                        locale: LocaleType.fr,
                        onConfirm: (time) {
                          setState(() {
                            date = time;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          image == null ? Text("Il faut mettre une image !", style: Theme.of(context).textTheme.headline4) : Text("")
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Annuler"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Ok"),
          onPressed: () async {
            if (image != null) {
              Photo p = new Photo(await DBProvider.db.getNextIdPhoto(), c.idCollection, File(image.path));
              c.ajouter(p);
              DBProvider.db.insererPhoto(p);
              p.setDescription(nouvelleDescription);
              p.setDateTime(date);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:provider/provider.dart';

class AlertChangerDescription extends StatefulWidget{

  final BuildContext contextPhoto;

  AlertChangerDescription(this.contextPhoto);

  @override
  State<StatefulWidget> createState() => AlertChangerDescriptionState(contextPhoto);
}

class AlertChangerDescriptionState extends State<AlertChangerDescription>{

  final BuildContext contextPhoto;
  String nouvelleDescription;
  DateTime nouvelleDate;
  Photo image;

  AlertChangerDescriptionState(this.contextPhoto){
    image = Provider.of<Photo>(contextPhoto);
    nouvelleDescription = image.description;
    nouvelleDate = image.dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Changer la description"),
      content: Column(
        children: <Widget>[
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
              controller: TextEditingController(text: image.description),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                nouvelleDate==null ? Text("") : IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      nouvelleDate = null;
                    });
                  },
                ),
                Text(nouvelleDate==null ? "" : nouvelleDate.toString().substring(0,10)),
                IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () async {
                    DatePicker.showDatePicker(context,
                      currentTime: DateTime.now(),
                      minTime: DateTime(1900, 1),
                      maxTime: DateTime.now(),
                      locale: LocaleType.fr,
                      onConfirm: (time) {
                        setState(() {
                          nouvelleDate = time;
                        });
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Annuler"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Ok"),
          onPressed: () {
            image.setDescription(nouvelleDescription);
            image.setDateTime(nouvelleDate);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
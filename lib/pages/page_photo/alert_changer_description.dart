import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  String nouvelleDescription = "";
  DateTime nouvelleDate;
  Photo image;

  AlertChangerDescriptionState(this.contextPhoto);

  @override
  Widget build(BuildContext context) {

    image = Provider.of<Photo>(contextPhoto);
    nouvelleDate = image.dateTime;

    return AlertDialog(
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
              children: <Widget>[
                Text(nouvelleDate==null ? "" : nouvelleDate.toString().substring(0,10)),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      nouvelleDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900, 1),
                          lastDate: DateTime.now()
                      );
                      setState(() {
                      });
                    },
                  ),
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
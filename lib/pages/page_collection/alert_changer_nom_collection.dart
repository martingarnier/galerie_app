import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:provider/provider.dart';


class AlertChangerNomCollection extends StatefulWidget{

  final BuildContext contextCollection;

  AlertChangerNomCollection(this.contextCollection);

  @override
  State<StatefulWidget> createState() => AlertChangerNomCollectionState(contextCollection);
}

class AlertChangerNomCollectionState extends State<AlertChangerNomCollection>{

  final BuildContext contextCollection;
  String nouveauNomCollection = "";
  String error = "Le nom doit contenir un caractère !";

  AlertChangerNomCollectionState(this.contextCollection);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text("Entrez le nouveau nom"),
      content: TextField(
        onChanged: (value) {
          nouveauNomCollection = value;
          setState(() {
            if(nouveauNomCollection == "") error = "Le nom doit contenir un caractère !";
            else if(Provider.of<Galerie>(context, listen: false).collections.any((collection) => collection.nom == nouveauNomCollection)) error = "Ce nom existe déjà !";
            else error = "";
          });
        },
        autofocus: true,
        decoration: InputDecoration(
          errorText: error,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Annuler"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Ok"),
          onPressed: (){
            if(error == ""){
              Provider.of<Collection>(contextCollection, listen: false).setNom(nouveauNomCollection);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
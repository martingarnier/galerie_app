import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/database.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:provider/provider.dart';

class AlertAjouterCollection extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AlertAjouterCollectionState();
}

class AlertAjouterCollectionState extends State<AlertAjouterCollection>{

  String nomCollection = "";
  Galerie g;
  String error = "Le nom doit contenir un caractère !";

  @override
  Widget build(BuildContext context) {

    g = Provider.of<Galerie>(context, listen: false);

    return AlertDialog(
      title: Text("Entrez le nom de la collection"),
      content: TextField(
        onChanged: (value) {
          nomCollection = value;
          setState(() {
            if(nomCollection == "") error = "Le nom doit contenir un caractère !";
            else if(g.collections.any((collection) => collection.nom == nomCollection)) error = "Ce nom existe déjà !";
            else error = "";
          });
        },
        decoration: InputDecoration(
          errorText: error,
        ),
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Annuler"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Ok"),
          onPressed: () async {
            if(error == ""){
              Collection c = new Collection(await DBProvider.db.getNextIdCollection(), nomCollection);

              g.ajouter(c);
              g.updateCollectionsFiltrees();
              DBProvider.db.insererCollection(c);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
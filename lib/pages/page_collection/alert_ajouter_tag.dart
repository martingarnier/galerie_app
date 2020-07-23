import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/database.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:provider/provider.dart';

class AlertAjouterTag extends StatefulWidget{

  final BuildContext contextCollection;

  AlertAjouterTag(this.contextCollection);

  @override
  State<StatefulWidget> createState() => AlertAjouterTagState(contextCollection);
}



class AlertAjouterTagState extends State<AlertAjouterTag>{

  String nouveauTag = "";
  final BuildContext contextCollection;
  Collection c;
  String error = "Un mot-clé doit contenir un caractère !";

  AlertAjouterTagState(this.contextCollection);

  @override
  Widget build(BuildContext context) {

    c = Provider.of<Collection>(contextCollection, listen: false);

    return AlertDialog(
      title: Text("Entrer un nouveau mot-clé"),
      content: TextField(
        onChanged: (value) {
          nouveauTag = value;
          setState(() {
            if(nouveauTag == "") error = "Un mot-clé doit contenir un caractère !";
            else if(c.tags.contains(nouveauTag)) error = "Cette collection possède déjà ce mot-clé !";
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
              c.ajouterTag(nouveauTag);
              DBProvider.db.insererTagCollection(nouveauTag, c.idCollection);

              Provider.of<Galerie>(context, listen: false).ajouterTag(nouveauTag);
              Provider.of<Recherche>(context, listen: false).updateTags(context);
              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:galerieapp/pages/page_resultat_photo/liste_resultat_photo.dart';
import 'package:provider/provider.dart';

class PageResultatPhoto extends StatelessWidget{

  Recherche recherche;

  @override
  Widget build(BuildContext context) {

    recherche = Provider.of<Recherche>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Résulat de la recherche",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: ListeResultatPhoto(recherche.resultatRecherchePhoto),
    );
  }
}
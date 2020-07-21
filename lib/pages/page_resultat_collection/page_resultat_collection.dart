import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:galerieapp/pages/page_resultat_collection/liste_resultat_collection.dart';
import 'package:provider/provider.dart';

class PageResultatCollection extends StatelessWidget{

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
      body: ListeResultatCollection(recherche.resultatRechercheCollection),
    );
  }
}
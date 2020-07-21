import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:galerieapp/pages/page_resultat_collection/boite_resultat_collection.dart';
import 'package:provider/provider.dart';

class ListeResultatCollection extends StatelessWidget{

  final List<Collection> listeCollections;

  ListeResultatCollection(this.listeCollections);

  @override
  Widget build(BuildContext context) {
    return Consumer<Recherche>(
      builder: (context, value, child) {
        return ListView(
          children:listeCollections.map((collection) => ChangeNotifierProvider.value(value: collection, child: BoiteResultatCollection(),)).toList(),
        );
      },
    );
  }
}
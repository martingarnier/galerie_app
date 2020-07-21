import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:galerieapp/pages/page_resultat_photo/boite_resultat_photo.dart';
import 'package:provider/provider.dart';

class ListeResultatPhoto extends StatelessWidget{

  final List<Photo> listePhotos;

  ListeResultatPhoto(this.listePhotos);

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      children: listePhotos.map((photo) {
        return ChangeNotifierProvider.value(
          value: photo,
          child: BoiteResultatPhoto(),
        );
      }).toList(),
      maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
    );
  }
}
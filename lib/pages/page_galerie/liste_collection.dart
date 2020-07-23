import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:galerieapp/pages/page_galerie/boite_collection.dart';
import 'package:provider/provider.dart';

class ListeCollection extends StatelessWidget{

  final _controllerTextField = TextEditingController();

  ListeCollection();

  @override
  Widget build(BuildContext context) {
    return Consumer<Galerie>(
      builder: (context, galerie, child) {
        return Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
              children: galerie.collectionsFiltrees.map((collection) => ChangeNotifierProvider.value(value: collection, child: BoiteCollection(),)).toList(),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 10),
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
                onChanged: (filtre) {
                  galerie.setFiltre(filtre);
                },
                controller: _controllerTextField,
                decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.black54,),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.black54,
                      onPressed: () {
                        _controllerTextField.clear();
                        galerie.setFiltre("");
                        galerie.updateCollectionsFiltrees();
                      },
                    )
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
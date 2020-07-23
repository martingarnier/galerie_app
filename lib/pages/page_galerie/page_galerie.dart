import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/pages/page_galerie/alert_ajouter_collection.dart';
import 'package:galerieapp/pages/page_galerie/liste_collection.dart';
import 'package:galerieapp/pages/page_galerie/menu_recherche.dart';



class PageGalerie extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          child: AppBar(
            elevation: 10,
            title: Text('Galerie', style: Theme.of(context).textTheme.headline1),
            centerTitle: true,
            actions: <Widget>[
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: MenuRecherche(),
        elevation: 10,
      ),
      body: GestureDetector(
        child: ListeCollection(),
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "ajouter_collection",
        onPressed: () {
          alertNouvelleCollection(context);
        },
        backgroundColor: AppBarTheme.of(context).color,
        foregroundColor: IconTheme.of(context).color,
        tooltip: 'Ajouter une collection',
        child: Icon(Icons.add),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void alertNouvelleCollection(BuildContext context){
    showDialog(context: context,
      builder: (context) {
        return AlertAjouterCollection();
      },
    );
  }

}
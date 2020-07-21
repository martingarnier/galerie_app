import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/database.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:galerieapp/pages/page_collection/boite_photo.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


class PageCollection extends StatefulWidget{

  final BuildContext contextCollection;

  PageCollection(this.contextCollection);

  @override
  State<StatefulWidget> createState() => PageCollectionState(contextCollection);
}


class PageCollectionState extends State<PageCollection>{

  BuildContext contextCollection;
  int _selectedIndex = 0;
  Recherche recherche;

  PageCollectionState(this.contextCollection);

  @override
  Widget build(BuildContext context) {
    Collection c = Provider.of<Collection>(contextCollection);
    recherche = Provider.of<Recherche>(context);

    return ChangeNotifierProvider.value(
      value: c,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            child: AppBar(
              title: Consumer<Collection>(
                builder: (context, value, child){
                  return Text(value.nom, style: Theme.of(context).textTheme.headline2);
                },
              ),
              elevation: 10,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){alertChangerNomCollection(context);},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){alertSupprimerCollection(context);},
                ),
              ],
            ),
          ),
        ),
        body: [
          Consumer<Collection>(
            builder: (context, value, child) {
              return GridView.extent(
                children: value.photos.map((photo) {
                  return ChangeNotifierProvider.value(
                    value: photo,
                    child: BoitePhoto(),
                  );
                }).toList(),
                maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
              );
            },
          ),
          Consumer<Collection>(
            builder: (context, value, child) {
              return ListView(
                children: listTags(value),
                padding: EdgeInsets.only(left: 20, right: 20),
              );
            },
          ),
        ][_selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            ImagePicker _picker = ImagePicker();
            PickedFile image = await _picker.getImage(source: ImageSource.gallery);
            print(image.path);

            //await ImagePicker.pickImage(source: ImageSource.gallery)

            Photo p = new Photo(await DBProvider.db.getNextIdPhoto(), c.idCollection, File(image.path));
            if (p.image != null) {
              c.ajouter(p);
              DBProvider.db.insererPhoto(p);
            }
          },
          backgroundColor: AppBarTheme.of(context).color,
          foregroundColor: IconTheme.of(context).color,
          tooltip: 'Ajouter une image',
          child: Icon(Icons.add_a_photo),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.collections),
                title: Text("Photos")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                title: Text("Tags")
            )
          ],
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          selectedItemColor: Colors.black,
        ),
      ),
    );
  }

  void alertChangerNomCollection(BuildContext context){
    String nouveauNomCollection = "";

    showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Entrez le nouveau nom"),
          content: TextField(
            onChanged: (value) => nouveauNomCollection = value,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: (){
                if(nouveauNomCollection != ""){
                  Provider.of<Collection>(contextCollection, listen: false).setNom(nouveauNomCollection);
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  void alertSupprimerCollection(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Supprimer la collection ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Provider.of<Galerie>(context, listen: false).supprimer(Provider.of<Collection>(contextCollection, listen: false));
                  recherche.updateTags(context);
                  recherche.updateResultatCollection(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  void alertAjouterTag(BuildContext context){
    String nouveauTag = "";

    showDialog(context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Entrez le nouveau tag"),
          content: TextField(
            onChanged: (value) => nouveauTag = value,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: (){
                if(nouveauTag != ""){
                  Collection c = Provider.of<Collection>(contextCollection, listen: false);
                  c.ajouterTag(nouveauTag);
                  DBProvider.db.insererTagCollection(nouveauTag, c.idCollection);

                  Provider.of<Galerie>(contextCollection, listen: false).ajouterTag(nouveauTag);
                  recherche.updateTags(context);
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  void alertSupprimerTag(BuildContext context, String tag){
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Supprimer le tag \"$tag\" ?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Provider.of<Collection>(contextCollection, listen: false).supprimerTag(tag);
                  Provider.of<Galerie>(contextCollection, listen: false).supprimerTag(tag);
                  recherche.updateTags(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  List<Widget> listTags(Collection value){

    List<Widget> liste = value.tags.map((tag) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(top: 15),
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(tag, style: Theme.of(context).textTheme.subtitle1,),
            ),
            Align(
              alignment: Alignment.centerRight,
              heightFactor: 0.5,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  alertSupprimerTag(context, tag);
                },
                iconSize: 20,
              ),
            )
          ],
        ),
      );
    }).toList();

    liste.add(Container(
      child: IconButton(
        icon: Icon(Icons.add_circle_outline),
        iconSize: 30,
        onPressed: () {
          alertAjouterTag(context);
        },
      ),
    )
    );
    return liste;
  }
}
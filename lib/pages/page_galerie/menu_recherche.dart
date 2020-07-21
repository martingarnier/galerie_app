import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:galerieapp/pages/page_resultat_collection/page_resultat_collection.dart';
import 'package:galerieapp/pages/page_resultat_photo/page_resultat_photo.dart';
import 'package:provider/provider.dart';

class MenuRecherche extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    Recherche recherche = Provider.of<Recherche>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Recherche", style: Theme.of(context).textTheme.headline2,),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              recherche.resetRecherche();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                padding: EdgeInsets.only(top: 20, bottom: 5, left: 10, right: 10),
                child: Consumer<Recherche>(
                  builder: (context, value, child) {
                    return ListView(
                        children: construireWidgetRecherche(context, value)
                    );
                  },
                ),
              )
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black12,
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
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            Text(" Photos", style: Theme.of(context).textTheme.subtitle2,)
                          ],
                        ),
                        onPressed: () {
                          recherche.updateResultatPhoto(context);
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (newContext) => PageResultatPhoto(),
                              )
                          );
                        },
                      ),
                    )
                ),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black12,
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
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            Text(" Collections", style: Theme.of(context).textTheme.subtitle2,)
                          ],
                        ),
                        onPressed: () {
                          recherche.updateResultatCollection(context);
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (newContext) => PageResultatCollection(),
                              )
                          );
                        },
                      ),
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  List<Widget> construireWidgetRecherche(BuildContext context, Recherche recherche){
    List<Widget> liste = recherche.listeTagsSelect.map((tag) {
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
                  recherche.updateTags(context);
                },
                iconSize: 20,
              ),
            )
          ],
        ),
      );
    }).toList();

    liste.add(Container(
      margin: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: FlatButton(
          child: Text(
            "Rechercher des tags",
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          color: Colors.black54,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          splashColor: Colors.grey,
          onPressed: () {
            recherche.updateTags(context);
            _openFilterList(context);
          },
        ),
      ),
    ));

    var _controllerTextField = TextEditingController();

    liste.insert(0,
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: TextField(
            onChanged: (value) {
              recherche.setTextRecherche(value);
              recherche.updateTags(context);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.black54,
                  onPressed: () {
                    _controllerTextField.clear();
                    recherche.setTextRecherche("");
                    recherche.updateTags(context);
                  },
                )
            ),
          ),
        )
    );

    return liste;
  }



  void alertSupprimerTag(BuildContext context, String tag){
    Recherche recherche = Provider.of<Recherche>(context, listen: false);

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
                  recherche.supprimerTagSelect(tag);
                  recherche.updateTags(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }



  void _openFilterList(BuildContext context) async {

    Recherche recherche = Provider.of<Recherche>(context, listen: false);

    var list = await FilterList.showFilterList(
      context,
      allTextList: recherche.listeTagsDispo,
      height: 450,
      borderRadius: 20,
      hideheaderText: true,

      searchFieldHintText: "Rechercher un tag",
      selectedTextList: recherche.listeTagsSelect,
    );

    if (list != null) {
      recherche.setListeTagsSelect(List.from(list));
    }

    recherche.updateTags(context);
  }

}
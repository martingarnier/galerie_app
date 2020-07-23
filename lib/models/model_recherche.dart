import 'package:flutter/cupertino.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:provider/provider.dart';

class Recherche extends ChangeNotifier{

  List<String> _listeTagsSelect;
  List<String> _listeTagsDispo;
  String _textRecherche;
  DateTime _dateDebut;
  DateTime _dateFin;
  List<Collection> _resultatRechercheCollection;
  List<Photo> _resultatRecherchePhoto;

  Recherche(){
    _listeTagsSelect = new List<String>();
    _listeTagsDispo = new List<String>();
    _textRecherche = "";
    _resultatRechercheCollection = new List<Collection>();
    _resultatRecherchePhoto = new List<Photo>();
  }

  List<String> get listeTagsSelect => _listeTagsSelect;
  List<String> get listeTagsDispo => _listeTagsDispo;
  String get textRecherche => _textRecherche;
  DateTime get dateDebut => _dateDebut;
  DateTime get dateFin =>  _dateFin;
  List<Collection> get resultatRechercheCollection => _resultatRechercheCollection;
  List<Photo> get resultatRecherchePhoto => _resultatRecherchePhoto;

  void setTextRecherche(String s){
    _textRecherche = s.toLowerCase();
    notifyListeners();
  }

  void setDateDebut(DateTime date){
    _dateDebut = date;
  }

  void setDateFin(DateTime date){
    _dateFin = date;
  }

  void ajouterTag(String tag){
    _listeTagsSelect.add(tag);
    notifyListeners();
  }

  void setListeTagsSelect(List<String> l){
    _listeTagsSelect = l;
    notifyListeners();
  }

  void supprimerTagSelect(String tag){
    _listeTagsSelect.remove(tag);
    notifyListeners();
  }

  void resetRecherche(){
    _listeTagsSelect.removeWhere((element) => true);
    _textRecherche = "";
    _dateDebut = null;
    _dateFin = null;
    notifyListeners();
  }

  void updateTags(BuildContext context){
    Galerie g = Provider.of<Galerie>(context, listen: false);

    _listeTagsDispo.clear();

    for(Collection collection in g.collections){
      collection.tags.forEach((element) { if(!listeTagsDispo.contains(element)) _listeTagsDispo.add(element);});
    }

    _listeTagsSelect.removeWhere((element) => !_listeTagsDispo.contains(element));
    notifyListeners();
  }

  void updateResultatCollection(BuildContext context){
    Galerie g = Provider.of<Galerie>(context, listen: false);

    listeTagsSelect.isNotEmpty ? _resultatRechercheCollection = g.collections.where((collection) => listeTagsSelect.every((tag) => collection.tags.contains(tag))).toList() : _resultatRechercheCollection = g.collections;
    notifyListeners();
  }

  void updateResultatPhoto(BuildContext context){
    updateResultatCollection(context);

    _resultatRecherchePhoto.clear();

    if(dateDebut != null){
      if(dateFin != null){
        _resultatRechercheCollection.forEach((collection) {
          collection.photos.forEach((photo) {
            if(photo.dateTime.isAfter(dateDebut) && photo.dateTime.isBefore(dateFin) && photo.description.toLowerCase().contains(textRecherche))_resultatRecherchePhoto.add(photo);
          });
        });
      }
      else{
        _resultatRechercheCollection.forEach((collection) {
          collection.photos.forEach((photo) {
            if(photo.dateTime.isAtSameMomentAs(dateDebut) && photo.description.toLowerCase().contains(textRecherche))_resultatRecherchePhoto.add(photo);
          });
        });
      }
    }
    else{
      textRecherche == "" ? _resultatRechercheCollection.forEach((collection) {_resultatRecherchePhoto.addAll(collection.photos);})
          : _resultatRechercheCollection.forEach((collection) {
        collection.photos.forEach((photo) {
          if(photo.description.toLowerCase().contains(textRecherche))_resultatRecherchePhoto.add(photo);
        });
      });
    }

    notifyListeners();
  }
}
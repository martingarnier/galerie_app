import 'package:flutter/cupertino.dart';
import 'package:galerieapp/database.dart';
import 'package:galerieapp/models/model_collection.dart';

class Galerie extends ChangeNotifier{

  List<Collection> _collections;
  List<Collection> _collectionsFiltrees;
  List<String> _tags;
  String _filtre;

  List<Collection> get collections => _collections;
  List<Collection> get collectionsFiltrees => _collectionsFiltrees;
  List<String> get tags => _tags;

  void setFiltre(String s){
    _filtre = s.toLowerCase();
    updateCollectionsFiltrees();
  }

  Galerie(){
    _collections = new List<Collection>();
    _collectionsFiltrees = new List<Collection>();
    _tags = new List<String>();
    _filtre = "";
  }

  void ajouter(Collection collection){
    _collections.add(collection);
    updateCollectionsFiltrees();
    notifyListeners();
  }

  void supprimer(Collection collection){
    _collections.remove(collection);
    DBProvider.db.supprimerCollection(collection.idCollection);
    updateCollectionsFiltrees();
    notifyListeners();
  }

  void ajouterTag(String s){
    _tags.add(s);
    notifyListeners();
  }

  void supprimerTag(String s){
    _tags.remove(s);
    notifyListeners();
  }
  
  void updateCollectionsFiltrees(){
    _collectionsFiltrees.clear();
    _collections.forEach((element) {
      if(element.nom.toLowerCase().contains(_filtre)) _collectionsFiltrees.add(element);
    });
    notifyListeners();
  }

}
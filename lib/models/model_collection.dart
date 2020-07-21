import 'package:flutter/cupertino.dart';
import 'package:galerieapp/database.dart';

import 'model_photo.dart';

class Collection extends ChangeNotifier{

  int _idCollection;
  String _nom;
  List<Photo> _photos;
  List<String> _tags;

  int get idCollection => _idCollection;
  String get nom => _nom;
  List<Photo> get photos => _photos;
  List<String> get tags => _tags;

  void setNom(String n){
    _nom = n;
    notifyListeners();
  }

  Collection(this._idCollection, this._nom){
    _photos = new List<Photo>();
    _tags = new List<String>();
  }

  void ajouter(Photo p){
    _photos.add(p);
    notifyListeners();
  }

  void supprimer(Photo p){
    _photos.remove(p);
    DBProvider.db.supprimerPhoto(p);
    notifyListeners();
  }

  void ajouterTag(String s){
    _tags.add(s);
    notifyListeners();
  }

  void supprimerTag(String s){
    _tags.remove(s);
    DBProvider.db.supprimerTagCollection(s, idCollection);
    notifyListeners();
  }

  Map<String, dynamic> toMap(){
    return{
      'id_collection': _idCollection,
      'nom_collection': _nom
    };
  }

}
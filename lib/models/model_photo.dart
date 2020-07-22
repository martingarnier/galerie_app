import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:galerieapp/database.dart';

class Photo extends ChangeNotifier{

  int _idPhoto;
  int _idCollection;
  File _image;
  String _description = "";
  DateTime _dateTime;

  int get idPhoto => _idPhoto;
  int get idCollection => _idCollection;
  File get image => _image;
  String get description => _description;
  DateTime get dateTime => _dateTime;

  Photo(this._idPhoto, this._idCollection, this._image);

  void setDescription(String d){
    _description = d;
    DBProvider.db.updatePhoto(this);
  }

  void setDateTime(DateTime d){
    _dateTime = d;
  }

  Map<String, dynamic> toMap(){
    return{
      'id_photo': _idPhoto,
      'id_collection': _idCollection,
      'description': _description,
      'date': _dateTime.toString()
    };
  }

}
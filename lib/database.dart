import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {

  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;
  bool estRempli = false;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();

    return _database;
  }

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'galerie_database.db'),
      onOpen: (db) async {
        //db.delete("photo");
      },
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE info(id_collection INTEGER, id_photo INTEGER, id_tag INTEGER)");
        await db.execute(
            "CREATE TABLE collection(id_collection INTEGER PRIMARY KEY, nom_collection TEXT)");
        await db.execute(
            "CREATE TABLE photo(id_photo INTEGER PRIMARY KEY, id_collection INTEGER, description TEXT)");
        await db.execute(
            "CREATE TABLE tag(id_collection INTEGER, nom_tag TEXT)");

        await db.insert('info', {
          'id_collection': 0,
          'id_photo': 0,
        });
      },
    );
  }



  Future<void> remplirModels(BuildContext context) async {
    if(!estRempli){
      (await collections()).forEach((collection) async {
        (await tagsCollection(collection.idCollection)).forEach((tag) {
          collection.ajouterTag(tag);
        });

        (await photosCollection(collection.idCollection)).forEach((photo) {
          collection.ajouter(photo);
        });

        Provider.of<Galerie>(context, listen: false).ajouter(collection);
        estRempli = true;
      });
      (await tags()).forEach((tag) {Provider.of<Galerie>(context, listen: false).ajouterTag(tag);});
    }
  }


  //---------------------- getNextId -----------------------

  Future<int> getNextIdCollection() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('info');

    int idCollection = maps[0]['id_collection'];

    await db.update(
        'info',
        {
          'id_collection': idCollection + 1,
          'id_photo': maps[0]['id_photo'],
        }
    );

    return idCollection;
  }

  Future<int> getNextIdPhoto() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('info');

    int idPhoto = maps[0]['id_photo'];

    await db.update(
        'info',
        {
          'id_collection': maps[0]['id_collection'],
          'id_photo': idPhoto + 1,
        }
    );

    return idPhoto;
  }


  //---------------------- Collection -----------------------

  Future<List<Collection>> collections() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('collection');

    return List.generate(maps.length, (i) {
      return new Collection(maps[i]['id_collection'], maps[i]['nom_collection']);
    });
  }

  Future<void> insererCollection(Collection collection) async {
    final Database db = await database;

    await db.insert(
      'collection',
      collection.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updateCollection(Collection collection) async {
    final db = await database;

    await db.update(
        'collection',
        collection.toMap(),
        where: 'id_collection = ?',
        whereArgs: [collection.idCollection]
    );
  }

  Future<void> supprimerCollection(int idCollection) async {
    final db = await database;

    await db.delete(
      'collection',
      where: 'id_collection = ?',
      whereArgs: [idCollection]
    );

    await db.delete(
      'tag',
      where: 'id_collection = ?',
      whereArgs: [idCollection]
    );
  }



//---------------------- Photo -----------------------

  Future<List<Photo>> photos() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('photo');

    List<Photo> listePhoto = new List<Photo>();

    for(int i = 0; i < maps.length; i++){
      File image = await lireImage(maps[i]['id_photo'].toString());

      Photo p = new Photo(maps[i]['id_photo'], maps[i]['id_collection'], image);
      p.setDescription(maps[i]['description']);

      listePhoto.add(p);
    }

    return listePhoto;
  }
  
  
  Future<List<Photo>> photosCollection(int idCollection) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM photo WHERE id_collection = $idCollection');

    List<Photo> listePhoto = new List<Photo>();

    for(int i = 0; i < maps.length; i++){
      File image = await lireImage(maps[i]['id_photo'].toString());

      Photo p = new Photo(maps[i]['id_photo'], maps[i]['id_collection'], image);
      p.setDescription(maps[i]['description']);

      listePhoto.add(p);
    }

    return listePhoto;
  }
  

  Future<void> insererPhoto(Photo photo) async {
    final Database db = await database;

    await db.insert(
        'photo',
        photo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    await ecrireImage(photo.idPhoto.toString(), photo.image);
  }

  Future<void> updatePhoto(Photo photo) async {
    final db = await database;

    await db.update(
        'photo',
        photo.toMap(),
        where: 'id_photo = ?',
        whereArgs: [photo.idPhoto]
    );
  }

  Future<void> supprimerPhoto(Photo photo) async {
    final db = await database;

    await db.delete(
        'photo',
        where: 'id_photo = ?',
        whereArgs: [photo.idPhoto]
    );

    supprimerImage(photo.idPhoto.toString());
  }







  //---------------------- Tag -----------------------

  Future<List<String>> tags() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT DISTINCT nom_tag FROM tag',);

    return List.generate(maps.length, (i) {
      return maps[i]['nom_tag'];
    });
  }

  Future<List<String>> tagsCollection(int idCollection) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT nom_tag FROM tag WHERE id_collection = $idCollection');

    return List.generate(maps.length, (i) {
      return maps[i]['nom_tag'];
    });
  }

  Future<List<int>> collectionsTag(String tag) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT id_collection FROM tag WHERE nom_tag = $tag');

    return List.generate(maps.length, (i) {
      return maps[i]['id_collection'];
    });
  }

  Future<void> insererTagCollection(String tag, int idCollection) async {
    final Database db = await database;

    await db.insert(
        'tag',
        {
          'id_collection': idCollection,
          'nom_tag': tag
        },
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> supprimerTagCollection(String tag, int idCollection) async {
    final db = await database;

    await db.delete(
        'tag',
        where: 'nom_tag = ? AND id_collection = ?',
        whereArgs: [tag, idCollection]
    );
  }


  //-------------------------------- File -------------------------------

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}';
  }

  Future<File> _imageFile(String nom) async {
    final path = await _localPath;
    return File('$path/image$nom.png');
  }

  Future<File> ecrireImage(String nom, File image) async {
    final file = await _imageFile(nom);
    return await image.copy(file.path);
  }

  Future<File> lireImage(String nom) async {
    try {
      final file = await _imageFile(nom);
      return file;
    }
    catch (e){
      return null;
    }
  }

  Future<void> supprimerImage(String nom) async {
    try{
      var file = await _imageFile(nom);
      if(await file.exists()) await file.delete();
    }
    catch (e){

    }
  }


}
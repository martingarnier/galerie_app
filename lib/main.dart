import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:galerieapp/database.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'file:///D:/Games/FlutterApp/myapp/galerie_app/lib/pages/page_galerie/page_galerie.dart';
import 'package:provider/provider.dart';

import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/models/model_galerie.dart';
import 'package:galerieapp/models/model_photo.dart';

void main() async{
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Galerie(),),
        ChangeNotifierProvider(create: (context) => Collection(0,""),),
        ChangeNotifierProvider(create: (context) => Photo(0,0,null),),
        ChangeNotifierProvider(create: (context) => Recherche(),)
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    DBProvider.db.remplirModels(context);

    return MaterialApp(
      title: 'Galerie Photo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        primaryColor: Colors.white,
        cardColor: Colors.black87,

        appBarTheme: const AppBarTheme(
          color: Colors.cyanAccent,
          elevation: 0,
        ),

        iconTheme: IconThemeData(
          color: Colors.black,
        ),

        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w800, color: Colors.black87),
          headline2: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w800, color: Colors.black87),
          headline3: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w800, color: Colors.white),
          bodyText1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800, color: Colors.white70),
          subtitle1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black),
          subtitle2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
          headline4: TextStyle(fontSize: 12.0, color: Colors.red)
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr')
      ],
      home: PageGalerie(),
    );
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_collection.dart';
import 'package:galerieapp/pages/page_collection/page_collection.dart';
import 'package:provider/provider.dart';


class BoiteResultatCollection extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.cyanAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(left: 10),
          color: Colors.white,
          height: 100,
          alignment: Alignment.center,
          child: ListTile(
            title: Consumer<Collection>(
              builder: (context, collection, child) {
                return Text(collection.nom, style: Theme.of(context).textTheme.headline2,);
              },
            ),
            trailing: Icon(Icons.keyboard_arrow_right, size: 50,),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (newContext) => PageCollection(context),
                  )
              );
            },
          ),
        )
    );
  }
}

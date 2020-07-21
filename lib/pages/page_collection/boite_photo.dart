import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerieapp/models/model_photo.dart';
import 'file:///D:/Games/FlutterApp/myapp/galerie_app/lib/pages/page_photo/page_photo.dart';
import 'package:provider/provider.dart';

class BoitePhoto extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (oldContext) => PagePhoto(context),
        ));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.cyan,
            border: Border.all(
              color: Colors.black,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Consumer<Photo>(
          builder: (context, value, child) {
            return value.image == null
                ? Text(value.idPhoto.toString())
                : ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.file(
                value.image,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
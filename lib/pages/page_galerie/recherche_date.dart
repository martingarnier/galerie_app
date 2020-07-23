import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:galerieapp/models/model_recherche.dart';
import 'package:provider/provider.dart';

class RechercheDate extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RechercheDateState();
}

class RechercheDateState extends State<RechercheDate>{

  DateTime date1;
  DateTime date2;

  @override
  Widget build(BuildContext context) {

    Recherche recherche = Provider.of<Recherche>(context);

    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 10),
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
            child: Consumer<Recherche>(
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    value.dateDebut==null ? Text("") : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          value.setDateDebut(null);
                        });
                      },
                    ),
                    Text(value.dateDebut==null ? "" : value.dateDebut.toString().substring(0,10), style: Theme.of(context).textTheme.subtitle1,),
                    IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () async {
                        DatePicker.showDatePicker(context,
                          currentTime: value.dateDebut==null ? (value.dateFin==null ? DateTime.now() : value.dateFin) : value.dateDebut,
                          minTime: DateTime(1900, 1),
                          maxTime: value.dateFin==null ? DateTime.now() : value.dateFin,
                          locale: LocaleType.fr,
                          onConfirm: (time) {
                            setState(() {
                              value.setDateDebut(time);
                            });
                          },
                        );
                      },
                    )
                  ],
                );
              },
            )
          ),
        ),
        Expanded(
          flex: 1,
          child: Icon(Icons.arrow_downward, size: 40,),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 10),
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
            child: Consumer<Recherche>(
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    value.dateFin==null ? Text("") : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          recherche.setDateFin(null);
                        });
                      },
                    ),
                    Text(value.dateFin==null ? "" : value.dateFin.toString().substring(0,10), style: Theme.of(context).textTheme.subtitle1),
                    IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () async {
                        DatePicker.showDatePicker(context,
                          currentTime: value.dateFin==null ? DateTime.now() : value.dateFin,
                          minTime: value.dateDebut==null ? DateTime(1900, 1) : value.dateDebut,
                          maxTime: DateTime.now(),
                          locale: LocaleType.fr,
                          onConfirm: (time) {
                            setState(() {
                              recherche.setDateFin(time);
                            });
                          },
                        );
                      },
                    )
                  ],
                );
              },
            )
          ),
        )
      ],
    );
  }
}
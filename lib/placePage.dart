import 'package:flutter/material.dart';

import 'place.dart';
import 'popUpMenu.dart';



class PlacePage extends StatelessWidget{

  final Place place;
  PlacePage(this.place);


  photo(){
    return new Container(
        child: new Image(
            image: AssetImage(place.imagenePath)
        )
    );
  }

  info(){
    return (SizedBox(
      height: 350,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(place.tittle,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(place.descripcion),
              leading: Icon(
                Icons.location_city,
                color: Colors.blue[500],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Lugares de interés"),
        actions: <Widget>[
          PopUpMenu(context).createPopUp()
        ],
      ),
      body: new ListView(
          children: <Widget>[
            photo(),
            info()
          ],
      ),
    );
  }
}
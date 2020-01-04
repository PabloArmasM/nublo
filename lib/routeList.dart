import 'package:flutter/material.dart';
import 'dart:convert';


import 'popUpMenu.dart';
import 'xmlReader.dart';
import 'place.dart';
import 'placePage.dart';
import 'main.dart';


class RouteMainList extends StatefulWidget{
  RouteList createState()=> RouteList();
}


class RouteList extends State<RouteMainList>{


  final _children = <Widget>[];
  var photoContainer;
  var _infoContent;
  var flag = true;


  RouteList (){
    createList();
  }

  generatePhoto(route){
    photoContainer = new Container(
        margin: new EdgeInsets.symmetric(
            vertical: 16.0
        ),
        alignment: FractionalOffset.centerLeft,
        child: CircleAvatar(
          backgroundImage: AssetImage(route),
          radius: 60,
        )
    );
  }


  infoContent(tittle){
    _infoContent=
        Container(
          width: 140,
          height: 200,
          margin:  new EdgeInsets.symmetric( horizontal: 50.0),
          alignment: FractionalOffset.center,
          child: Text(tittle, style: new TextStyle(fontSize:  17),),
        );
  }

  void createList(){
    XmlReader().getRouteMarkers().then((value){
      var data = json.decode(value);
      var i = 1;
      while(data[i.toString()] != null) {
        var actual = data[i.toString()];
        generatePhoto(actual["imagenePath"]);
        infoContent(actual["tittle"]);

        setState((){
          _children.add(
              GestureDetector(
                  onTap: (){
                    //var page = PlacePage(new Place(actual["tittle"], actual["descripcion"], actual["latitude"], actual["longitude"], actual["imagenePath"]));
                    XmlReader.setPolyRoute(actual["route"]);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateMapRoute()));
                    //print("todo el conjunt");
                  },
                  child: Row(
                      children: <Widget>[
                        photoContainer,
                        _infoContent
                      ]
                  )
              )
          );
        });
        i++;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    /*if(flag) {
      createList();
      flag = false;
    }*/
    return new Scaffold(
        appBar: new AppBar(title: Text("Rutas"),
          actions: <Widget>[
            PopUpMenu(context).createPopUp()
          ],
        ),
        body: new ListView.builder(
            itemCount: _children.length,
            itemBuilder: (BuildContext context, int index){
              return _children[index];
            })
    );
  }

}
import 'package:flutter/material.dart';
import 'listPlaces.dart' as places;
import 'routeList.dart' as route;

class PopUpMenu {


  static const List<String> choices = <String>[
    'Itinerarios', 'Lugares de interés', 'Rutas'];

  var _context;

  PopUpMenu(context){
    _context = context;
  }

  Widget createPopUp(){
    return(
        PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context){
            return choices.map((String choice){
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        )
    );
  }

  void choiceAction(String choice){
    if(choice == 'Itinerarios'){
      print('Settings');
    }else if(choice == 'Lugares de interés'){
      Navigator.push(_context, MaterialPageRoute(builder: (context) => places.ListMainPage()));
    }else if(choice == 'Rutas'){
      Navigator.push(_context, MaterialPageRoute(builder: (context) => route.RouteMainList()));
    }
  }

}
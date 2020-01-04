import 'package:flutter/material.dart';


class CardsLayer{

  var data =[];

  SizedBox getCards(tittle, descripcion){
    return (SizedBox(
      height: 210,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(tittle,
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(descripcion),
              leading: Icon(
                Icons.location_city,
                color: Colors.blue[500],
              ),
            ),
            /*Divider(),
            ListTile(
              title: Text('(408) 555-1212',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              leading: Icon(
                Icons.contact_phone,
                color: Colors.blue[500],
              ),
            ),
            ListTile(
              title: Text('costa@example.com'),
              leading: Icon(
                Icons.contact_mail,
                color: Colors.blue[500],
              ),
            ),*/
          ],
        ),
      ),
    ));
  }


}

/*
class TravelDestinationContent extends StatelessWidget {
  const TravelDestinationContent({ Key key, @required this.destination })
      : assert(destination != null),
        super(key: key);

  final TravelDestination destination;



    r
*/
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'dart:convert';


import 'xmlReader.dart';
import 'popUpMenu.dart';
import 'listPlaces.dart' as places;
import 'place.dart';
import 'placePage.dart';
//import 'choiceSelecter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nublo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',

      routes: {
        '/': (context) => MyHomePage(title: "Nublo Home"),
        '/polyMap':(context) => GenerateMapRoute(),
        '/listPlaces':(context) => places.ListMainPage()
      }
      //home: MyHomePage(title: 'Nublo Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}




class _MyHomePageState extends State<MyHomePage> {

  /*var currentLocation = <String, double>{};

  var location = new Location();*/
    //var xmlReader = new XmlReader();

    static var latitude = 27.8;
    static var longitude= -15.6;
    //Widget child;

    var markers = <Marker>[];

    var userPosition = <Marker>[];
    SizedBox cards;
    var _children= <Widget>[];


    var tittle;
    var descripcion;
    var _info;
    var _route;


    var _center =  new LatLng(27.95,-15.55);

    final MapController controller = new MapController();

    _MyHomePageState(){
      cleanChildren();
      getMap();
      getLocation();
      chargueMarkets();
    }

    chargueMarkets(){
      var xml = new XmlReader();
      xml.getMarkers().then((value){
          var data = json.decode(value);
          var i = 1;
          while(data[i.toString()] != null){
            var actual = data[i.toString()];
            markers.add(
            new Marker(
              width: 45.0,
              height: 45.0,
              point: new LatLng(actual["latitude"], actual["longitude"]),
              builder: (context) => new Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.red,
                  iconSize: 30.0,
                  onPressed: () {
                    tittle = actual["tittle"];
                    descripcion = actual["descripcion"];
                    _info = "Seguir leyendo";
                    _route = GenerateMapRoute();
                    setState(() {
                      addSizebox(new Place(actual["tittle"], actual["descripcion"], actual["latitude"], actual["longitude"], actual["imagenePath"]), true);
                    });
                    //addCards(CardsLayer().getCards(actual["tittle"], actual["descripcion"]));
                    //cards = CardsLayer().getCards(actual["tittle"], actual["descripcion"]);
                    //Widget child;
                    //child: CardsLayer(new MarkerData(tittle: actual["tittle"], descripcion: actual["descripcion"], imagenePath: actual["imagenePath"]));
                    //print(i.toString() + " " + actual["tittle"]);
                  },
                ),
              ))
            );
            i++;
          }
      });

      xml.getRouteMarkers().then((value){
        var data = json.decode(value);
        var i = 1;
        while(data[i.toString()] != null){
          var actual = data[i.toString()];
          markers.add(
              new Marker(
                  width: 45.0,
                  height: 45.0,
                  point: new LatLng(actual["latitude"], actual["longitude"]),
                  builder: (context) => new Container(
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.green,
                      iconSize: 30.0,
                      onPressed: () {
                        tittle = actual["tittle"];
                        descripcion = "";
                        _info = "Ver ruta";
                        _route = GenerateMapRoute();
                        XmlReader.setPolyRoute(actual["route"]);
                        setState(() {
                          addSizebox(new Place(actual["tittle"], actual["descripcion"], actual["latitude"], actual["longitude"], actual["imagenePath"]), false);
                        });
                      },
                    ),
                  ))
          );
          i++;
        }
      });

      /*for(var i in data){
        print(i);
      }*/
    }



    addSizebox(Place place, bool isPlace){
      setState(() {
        var icon;
        double _heigth = 250.0;
        if(isPlace)
          icon = Icons.location_city;
        else {
          icon = Icons.directions_walk;
          _heigth = 200;
        }
        if(_children.length > 1)
          _children.removeAt(0);
        _children.insert(0,
            SizedBox(
              height: _heigth,
              child: Card(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(tittle,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(descripcion),
                      leading: Icon(
                        icon,
                        color: Colors.blue[500],
                      ),
                    ),
                    ListTile(
                      subtitle: Text(_info),
                      onTap: (){
                        if(isPlace)
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePage(place)));
                        else
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>GenerateMapRoute()));
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.close),
                        color: Colors.blue,
                        iconSize: 30.0,
                        onPressed: () {
                          setState(() {
                            _children.removeAt(0);
                          });
                        })
                  ],
                ),
              ),
            )
        );
      });
    }


    var location = new Location();
    var flag = false;
    var flagIni = false;
    getLocation (){
      location.onLocationChanged().listen((LocationData value){
        flag = true;
        latitude = value.latitude;
        longitude = value.longitude;
        controller.move(LatLng(latitude, longitude), controller.zoom);
        if(userPosition.isNotEmpty)
          userPosition.removeLast();
        userPosition.add(new Marker(
            width: 45.0,
            height: 45.0,
            point: new LatLng(value.latitude, value.longitude),
            builder: (context) => new Container(
              child: IconButton(
                icon: Icon(Icons.trip_origin),
                color: Colors.brown,
                iconSize: 30.0,
                onPressed: () {
                  print('Marker tapped');
                },
              ),
            )));
      });
    }

    getMap(){
        _children.add(Flexible(child:
            FlutterMap(
                mapController: controller,
                options: new MapOptions(
                center: _center,
                minZoom: 10.0,
                nePanBoundary: new LatLng(28.1353929, -15.3565448),
                swPanBoundary: new LatLng(27.7982475, -15.7538075),
              ),
                layers: [
                new TileLayerOptions(
                    urlTemplate:
                    "https://api.mapbox.com/styles/v1/rajayogan/cjl1bndoi2na42sp2pfh2483p/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibG9lZGRlZCIsImEiOiJjanN5eGEyMjMwZzgyNDdybnlwZnk1MTFkIn0.OGppdJJRCRKbrwv-9gIm3A",
                    additionalOptions: {
                      'accessToken':
                      'pk.eyJ1IjoibG9lZGRlZCIsImEiOiJjanN5eGEyMjMwZzgyNDdybnlwZnk1MTFkIn0.OGppdJJRCRKbrwv-9gIm3A',
                      'id': 'mapbox.mapbox-streets-v7'
                      //offlineMode: true,
                      //maxZoom: 15,
                      //urlTemplate: "assets/maps/grancanaria/{z}/{x}/{y}.png"
                    }),
                new MarkerLayerOptions(markers: this.markers),
                new MarkerLayerOptions(markers: this.userPosition),
              ])
            )
          );
        }

    /*Flexible(
    child: getMap()
    ),*/

    cleanChildren(){
      _children = <Widget> [];
    }
    @override
    Widget build(BuildContext context) {
      /*if(!flagIni) {
        cleanChildren();
        getMap();
        getLocation();
        chargueMarkets();
        flagIni = !flagIni;
      }*/
      return new Scaffold(
      appBar: new AppBar(title: Text("Nublo"),
        actions: <Widget>[
          PopUpMenu(context).createPopUp()
        ],
      ),
      body:
      Column(children : _children));
    }
}







/*


Poly



 */


class GenerateMapRoute extends StatelessWidget{

  final MapController controller = new MapController();

  final latitude = 27.8;
  final longitude= -15.6;
  final userPosition = <Marker>[];


  final location = new Location();
  getLocation (){
    print("eto no funciona");
    location.onLocationChanged().listen((LocationData value){
      controller.move(LatLng(value.latitude, value.longitude), controller.zoom);
      if(userPosition.isNotEmpty)
        userPosition.removeLast();
      userPosition.add(new Marker(
          width: 45.0,
          height: 45.0,
          point: new LatLng(value.latitude, value.longitude),
          builder: (context) => new Container(
            child: IconButton(
              icon: Icon(Icons.trip_origin),
              color: Colors.brown,
              iconSize: 30.0,
              onPressed: () {
                print('Marker tapped');
              },
            ),
          )));
    });
  }


  @override
  Widget build(BuildContext context) {
    getLocation();
    return Scaffold(
        appBar: new AppBar(title: Text("Nublo"),
          actions: <Widget>[
            PopUpMenu(context).createPopUp()
          ],
        ),
      body:
      FlutterMap(
          mapController: controller,
          options: new MapOptions(
              center: new LatLng(latitude, longitude), minZoom: 5.0),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                "https://api.mapbox.com/styles/v1/rajayogan/cjl1bndoi2na42sp2pfh2483p/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibG9lZGRlZCIsImEiOiJjanN5eGEyMjMwZzgyNDdybnlwZnk1MTFkIn0.OGppdJJRCRKbrwv-9gIm3A",
                additionalOptions: {
                  'accessToken':
                  'pk.eyJ1IjoibG9lZGRlZCIsImEiOiJjanN5eGEyMjMwZzgyNDdybnlwZnk1MTFkIn0.OGppdJJRCRKbrwv-9gIm3A',
                  'id': 'mapbox.mapbox-streets-v7'
                }),
            new MarkerLayerOptions(markers: this.userPosition),
            new PolylineLayerOptions(
              polylines: [
                        new Polyline(
                            points: XmlReader().getRoute(),
                            strokeWidth: 4.0,
                            color: Colors.red
                        )
                      ]
            )
          ])
    );
  }
}
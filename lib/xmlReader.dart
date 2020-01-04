import 'package:xml2json/xml2json.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:latlong/latlong.dart';
//import 'dart:async' show Future


class XmlReader{

  var route='assets/routesGPS/';
  var markerPath = 'assets/markers/markers.json';
  var routesPath = 'assets/markers/rutasMarkers.json';

  var info = <LatLng>[];
  final Xml2Json myTransformer = Xml2Json();
  var markers;
  var routeM;
  static var polyRoute;

  XmlReader(){
    markers = readMarkerData();
    routeM = readRoutesStart();
  }

  setRoute(route){
    this.route = route;
  }

  static setPolyRoute(route){
    polyRoute = route;
  }

  getRoute(){
    chargeData();
    return(info);
  }

  Future<String> getRouteMarkers(){
    return routeM;
  }

  Future<String> getMarkers(){
    return markers;
  }

  chargeData() async{
    print(polyRoute);
    var document = await rootBundle.loadString(route+polyRoute);
    myTransformer.parse(document);
    String json = myTransformer.toBadgerfish();
    var data = jsonDecode(json)['gpx']['trk']['trkseg']['trkpt'];
    for(var x in data){
      info.add(new LatLng(double.parse(x['@lat']), double.parse(x['@lon'])));
    }
    //var document = xml.parse(roue+doc);
    //print(document.toString());
  }

  Future<String> readMarkerData() async{
    var document = await rootBundle.loadString(markerPath);
    return document;
  }

  Future<String> readRoutesStart() async{
    var document = await rootBundle.loadString(routesPath);
    return document;
  }



}
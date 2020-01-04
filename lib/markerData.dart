import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class MarkerData{

  const MarkerData({
      @required this.tittle,
      @required this.descripcion,
      @required this.imagenePath
  }): assert(tittle != null),
  assert(descripcion != null),
  assert(imagenePath != null);

  final String tittle;
  final String descripcion;
  final String imagenePath;

}
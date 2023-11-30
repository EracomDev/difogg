import 'package:flutter/material.dart';

class HomeMenu{
  String   _name;
  Widget _image;

  HomeMenu(
      {@required image,
        @required name,
      }
      ):_image = image,
        _name = name;


  Widget get image =>_image;
  String get name => _name;
}
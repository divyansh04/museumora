import 'package:flutter/material.dart';

abstract class Global {
  static const Color blue = const Color(0xff4A64FE);

  static const List rooms = [
    {
      'location': 'Room 1',
      'name': 'R1',
      'status': false,
      'position': [0.0, 0.0],
      'tile': 1,
    },
    {
      'location': 'Office 01',
      'name': 'O-1',
      'status': true,
      'position': [-0.07, 0.0],
      'tile': 2,
    },
    {
      'location': 'Meeting room',
      'name': 'M-R',
      'status': false,
      'position': [0.08, 0.0],
      'tile': 2,
    },
    {
      'location': 'Office 02',
      'name': 'O-2',
      'status': true,
      'position': [0.0, 0.0],
      'tile': 3,
    },
    {
      'location': 'Box Office',
      'name': 'Box-Office',
      'status': true,
      'position': [-0.07, -0.02],
      'tile': 4,
    },
    {
      'location': 'Hall',
      'name': 'Hall',
      'status': false,
      'position': [0.05, 0.0],
      'tile': 4,
    },
    {
      'location': 'Entrance',
      'name': 'Entrance',
      'status': true,
      'position': [-0.05, 0.1],
      'tile': 4,
    },
    {
      'location': 'Utility Room 1',
      'name': 'U-1',
      'status': true,
      'position': [0.0, 0.0],
      'tile': 8,
    },
  ];
}

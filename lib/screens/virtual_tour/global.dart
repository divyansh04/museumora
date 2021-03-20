import 'package:flutter/material.dart';

abstract class Global {
  static const Color blue = const Color(0xff4A64FE);

  static const List rooms = [
    {
      'location': 'Research Room (Library)',
      'name': 'Library',
      'status': false,
      'position': [0.0, 0.0],
      'tile': 1,
    },
    {
      'location': 'Slavic Culture Exhibit',
      'name': 'Slavic',
      'status': true,
      'position': [-0.07, 0.0],
      'tile': 2,
    },
    {
      'location': 'Mufford Exhibit',
      'name': 'Mufford',
      'status': false,
      'position': [0.08, 0.0],
      'tile': 2,
    },
    {
      'location': 'Music Hall',
      'name': 'Music-Hall',
      'status': true,
      'position': [0.0, 0.0],
      'tile': 3,
    },
    {
      'location': 'McKusic Exhibit',
      'name': 'McK',
      'status': false,
      'position': [0.0, -0.09],
      'tile': 4,
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
      'position': [0.08, -0.15],
      'tile': 7,
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

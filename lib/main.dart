import 'package:flutter/material.dart';
import 'package:notekeeper/screens/notelist.dart';
import 'package:notekeeper/screens/notedetail.dart';

import 'screens/notedetail.dart';

void main() {
  runApp(NoteKeeper());
}
class NoteKeeper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: NoteList(),
    );
  }
}